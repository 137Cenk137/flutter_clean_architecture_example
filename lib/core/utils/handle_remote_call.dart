import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

Future<T> handleRemoteCallException<T>({
  required Future<T> Function() function,
  Exception Function(Object e)? exceptionMapper,
}) async {
  try {
    return await function();
  } on sb.AuthException catch (e) {
    throw ServerExcepiton(e.toString());
  } catch (e) {
    if (exceptionMapper != null) {
      throw exceptionMapper(e);
    }
    throw ServerExcepiton(e.toString());
  }
}

/* Example usage:
final user = await handleRemoteCall(
  () => supabase.auth.signInWithPassword(...),

  // We provide a strategy for mapping exceptions
  exceptionMapper: (e) {
    if (e is sb.AuthException) {
      return ServerExcepiton(e.message); // Or a more specific AuthFailureException
    }
    // You can now handle any other exception type here without
    // ever touching the handleRemoteCall function again.
    if (e is SocketException) {
      return NetworkException("Please check your internet connection.");
    }
    // A fallback for any other unexpected errors.
    return ServerExcepiton(e.toString());
  },
);
 */
