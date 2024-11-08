class Urls{
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';
  static const String registerUrl = '$_baseUrl/Registration';
  static const String loginUrl = '$_baseUrl/Login';
  static const String addNewTask = '$_baseUrl/createTask';
  static const String profileUpdate = '$_baseUrl/ProfileUpdate';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static const String addNewTaskList = '$_baseUrl/listTaskByStatus/New';
  static const String addCompleteTaskList = '$_baseUrl/listTaskByStatus/Completed';
  static const String addProgressTaskList = '$_baseUrl/listTaskByStatus/Progress';
  static const String addCancelTaskList = '$_baseUrl/listTaskByStatus/Cancelled';
  static const String verifyEmail = '$_baseUrl/RecoverVerifyEmail/';
  static const String verifyOtp = '$_baseUrl/RecoverVerifyOtp/';
  static const String setNewPass = '$_baseUrl/RecoverResetPassword';

  static String selectTaskStatus(String taskId,String status) =>
      '$_baseUrl/updateTaskStatus/$taskId/$status';
  static String deleteTask(String taskId) =>
      '$_baseUrl/deleteTask/$taskId';
}