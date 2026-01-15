import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import 'user_profile_model.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserProfileRepository(dio: dio);
});

class UserProfileRepository {
  final Dio _dio;

  UserProfileRepository({required Dio dio}) : _dio = dio;

  Future<UserProfile> getMyProfile() async {
    try {
      print('Fetching user profile');
      
      final response = await _dio.get('/Account/me');

      print('Profile response status: ${response.statusCode}');
      print('Profile response data type: ${response.data.runtimeType}');
      print('Profile response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('Server returned null data');
        }

        final data = response.data as Map<String, dynamic>;
        print('Profile data keys: ${data.keys.toList()}');
        
        // Backend wraps the response in {user: {...}, vendorProfile: null, staffProfile: null}
        final userData = data.containsKey('user') && data['user'] != null
            ? data['user'] as Map<String, dynamic>
            : data;
        
        print('User data keys: ${userData.keys.toList()}');
        print('FirstName field: ${userData['firstName'] ?? userData['FirstName']}');
        print('Email field: ${userData['email'] ?? userData['Email']}');
        
        return UserProfile.fromJson(userData);
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException loading profile: ${e.response?.statusCode} - ${e.response?.data}');
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication required. Please log in again.');
      }
      throw Exception('Failed to load profile: ${e.response?.statusCode ?? e.message}');
    } catch (e) {
      print('Error loading profile: $e');
      rethrow;
    }
  }

  Future<UserProfile> updateMyProfile(UpdateProfileRequest request) async {
    try {
      print('Updating user profile: ${request.toJson()}');
      
      final formData = FormData.fromMap({
        'FirstName': request.firstName,
        'LastName': request.lastName,
        'Email': request.email,
        'PhoneNumber': request.phoneNumber,
      });

      final response = await _dio.put(
        '/Account/me',
        data: formData,
      );

      print('Profile update response status: ${response.statusCode}');
      print('Profile update response data type: ${response.data.runtimeType}');
      print('Profile update response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('Server returned null data');
        }

        final data = response.data as Map<String, dynamic>;
        print('Update response keys: ${data.keys.toList()}');
        print('Updated FirstName: ${data['firstName'] ?? data['FirstName']}');
        
        return UserProfile.fromJson(data);
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException updating profile: ${e.response?.statusCode} - ${e.response?.data}');
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        String errorMessage = 'Invalid profile data.';
        
        if (errorData is Map<String, dynamic>) {
          errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
        }
        
        throw Exception(errorMessage);
      } else if (e.response?.statusCode == 401) {
        throw Exception('Authentication required. Please log in again.');
      }
      throw Exception('Failed to update profile: ${e.response?.statusCode ?? e.message}');
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
}
