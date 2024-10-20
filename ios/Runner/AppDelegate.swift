import UIKit
import Flutter
import BackgroundTasks
import WidgetKit

//private let devicesUpdateBackgroundTaskId = "lightify.ds.devicesUpdate.backgroundTask"
//private let devicesUpdateBackgroundTaskFreq = 60 // mins

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
//        if #available(iOS 17.0, *) {
////            BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: devicesUpdateBackgroundTaskId)
//            BGTaskScheduler.shared.register(forTaskWithIdentifier: devicesUpdateBackgroundTaskId, using: nil) { task in
//                guard let task = task as? /*BGProcessingTask*/ BGAppRefreshTask else { return }
//                self.handleBackgroundTask(task: task)
//            }
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                BGTaskScheduler.shared.getPendingTaskRequests { requests in
//                    if (!requests.isEmpty) {
//                        return
//                    }
//                    self.scheduleNextBackgroundProcessingTask { isSuccess in
////                        NSLog("AppDelegate scheduleNextBackgroundProcessingTask isSuccess: \(isSuccess.description)")
//                    }
//                }
//            }
//        }
        
//        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//        let backgroundTasksChannel = FlutterMethodChannel(name: "native/devicesBackground", binaryMessenger: controller.binaryMessenger)
//        
//        backgroundTasksChannel.setMethodCallHandler({
//            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//            /*if (call.method == "schedule") {
//                self.scheduleNextAppRefresh { isSuccess in
//                    print("scheduleNextAppRefresh isSuccess: \(isSuccess.description)")
//                    result(isSuccess)
//                }
//                return
//            } else*/ if (call.method == "tasksCount") {
//                let count = self.getBGTasksCount()
//                result(count)
//                return
//            } else if (call.method == "reset") {
//                BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: devicesUpdateBackgroundTaskId)
//                result(true)
//                return
//            } else {
//                result(FlutterMethodNotImplemented)
//                return
//            }
//        })
        
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
//    override func applicationDidEnterBackground(_ application: UIApplication) {
//        if #available(iOS 17.0, *) {
//            BGTaskScheduler.shared.getPendingTaskRequests { requests in
////                NSLog("Background tasks scheduled: \(requests.count.description)")
//                if (!requests.isEmpty) {
//                    return
//                }
//                self.scheduleNextBackgroundProcessingTask { isSuccess in
////                    NSLog("applicationDidEnterBackground scheduleNextBackgroundProcessingTask isSuccess: \(isSuccess.description)")
//                }
//            }
//        }
//    }
    
//    private func handleBackgroundTask(task: BGAppRefreshTask) {
//        incrBGTasksCount() // debug
//        
//        scheduleNextBackgroundProcessingTask { isSuccess in
////            NSLog("ScheduleNextBackgroundProcessingTask isSuccess: \(isSuccess.description)")
//        }
//        
//        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 1
//        queue.qualityOfService = .background
//        
//        if #available(iOS 17.0, *) {
//            let devicesBackgroundUpdateOperation = MQTTDevicesBackgroundUpdate()
//            queue.addOperation(devicesBackgroundUpdateOperation)
//        }
//        
//        task.expirationHandler = {
//            queue.cancelAllOperations()
//        }
//        
//        let lastOperation = queue.operations.last
//        lastOperation?.completionBlock = {
//            task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
//        }
//    }
    
//    func scheduleNextBackgroundProcessingTask(completion: @escaping(Bool) -> Void) {
//        
//        let request = /*BGProcessingTaskRequest*/BGAppRefreshTaskRequest(identifier: devicesUpdateBackgroundTaskId)
////        request.requiresNetworkConnectivity = true
////        request.requiresExternalPower = false
//        request.earliestBeginDate = Date(timeIntervalSinceNow: TimeInterval(devicesUpdateBackgroundTaskFreq * 60)) // Refresh time
//        
//        do {
//            try BGTaskScheduler.shared.submit(request)
////            NSLog("FlutterApp Next Background Processing Task scheduled successfully.")
//            completion(true)
//        } catch {
////            NSLog("FlutterApp Unable to schedule next Background Processing Task: \(error)")
//            completion(false)
//        }
//    }
    
//    func getBGTasksCount() -> Int {
//        let count = UserDefaults.standard.integer(forKey: "bg_tasks_count")
//        return count
//    }
//    
//    func incrBGTasksCount() -> Void {
//        let currentCount = getBGTasksCount()
//        UserDefaults.standard.set(currentCount + 1, forKey: "bg_tasks_count")
//    }
}
