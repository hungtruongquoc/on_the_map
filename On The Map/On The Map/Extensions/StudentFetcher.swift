import Foundation

class StudentFetcher {
    static let shared = StudentFetcher()
    
    typealias StudentListUpdateHandler = (_ studentList: [StudentInformation], _ error: Error?) -> Void
    private var updateHandlers: [StudentListUpdateHandler] = []
    private var isFetching = false
    private var studentListCache: [StudentInformation]?
    
    private init() {} // Private initializer to enforce singleton usage
    
    private var shouldReloadList = true
        
    // Existing properties and methods...

    func setShouldReloadList(_ shouldReload: Bool) {
        shouldReloadList = shouldReload
        if shouldReloadList {
            Task {
                await fetchStudents()
            }
        }
    }
    
    func getShouldReloadList() -> Bool {
        return shouldReloadList
    }
    
    private func notifySubscribers(with studentList: [StudentInformation], error: Error? = nil) {
        for handler in updateHandlers {
            handler(studentList, error)
        }
    }
    
    func fetchStudents() async {
        guard shouldReloadList && !isFetching else {
            // If already fetching or no need to reload, notify with cached data if available
            if let cachedList = studentListCache {
                notifySubscribers(with: cachedList, error: nil)
            }
            return
        }
        
        isFetching = true

        do {
            let studentList = try await StudentNetworkHandler.shared.fetchStudents()
            await MainActor.run {
                self.studentListCache = studentList.results // Cache the fetched results
                self.notifySubscribers(with: studentList.results, error: nil)
            }
        } catch {
            await MainActor.run {
                self.notifySubscribers(with: [], error: error)
            }
        }
        
        shouldReloadList = false
        isFetching = false
    }
    
    func subscribeToStudentListUpdated(handler: @escaping StudentListUpdateHandler) {
        updateHandlers.append(handler)
    }
    
    func forceRefreshStudentList() {
        studentListCache = nil // Invalidate cache
        setShouldReloadList(true)
    }
    
    func studentExists(withUniqueKey key: String) -> Bool {
        // Check if the studentList is not nil and not empty
        guard let list = studentListCache, !list.isEmpty else {
            return false
        }
        
        // Search for a student with the matching uniqueKey
        return list.contains(where: { $0.uniqueKey == key })
    }
}
