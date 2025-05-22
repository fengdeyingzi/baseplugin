


import 'dart:convert';
import 'dart:typed_data';

class FileMode {
  /// The mode for opening a file only for reading.
  static const read = const FileMode._internal(0);

  /// Mode for opening a file for reading and writing. The file is
  /// overwritten if it already exists. The file is created if it does not
  /// already exist.
  static const write = const FileMode._internal(1);

  /// Mode for opening a file for reading and writing to the
  /// end of it. The file is created if it does not already exist.
  static const append = const FileMode._internal(2);

  /// Mode for opening a file for writing *only*. The file is
  /// overwritten if it already exists. The file is created if it does not
  /// already exist.
  static const writeOnly = const FileMode._internal(3);

  /// Mode for opening a file for writing *only* to the
  /// end of it. The file is created if it does not already exist.
  static const writeOnlyAppend = const FileMode._internal(4);

  final int _mode;

  const FileMode._internal(this._mode);
}

abstract class File {
  /// Creates a [File] object.
  ///
  /// If [path] is a relative path, it will be interpreted relative to the
  /// current working directory (see [Directory.current]), when used.
  ///
  /// If [path] is an absolute path, it will be immune to changes to the
  /// current working directory.
  @pragma("vm:entry-point")
  factory File(String path) {
    throw Exception('Not implemented');
  }

  /// Create a [File] object from a URI.
  ///
  /// If [uri] cannot reference a file this throws [UnsupportedError].
  factory File.fromUri(Uri uri) => new File(uri.toFilePath());

  /// Creates a [File] object from a raw path.
  ///
  /// A raw path is a sequence of bytes, as paths are represented by the OS.
  @pragma("vm:entry-point")
  factory File.fromRawPath(Uint8List rawPath) {
    throw Exception('Not implemented');
  }

  /// Creates the file.
  ///
  /// Returns a `Future<File>` that completes with
  /// the file when it has been created.
  ///
  /// If [recursive] is `false`, the default, the file is created only if
  /// all directories in its path already exist. If [recursive] is `true`, any
  /// non-existing parent paths are created first.
  ///
  /// If [exclusive] is `true` and to-be-created file already exists, this
  /// operation completes the future with a [PathExistsException].
  ///
  /// If [exclusive] is `false`, existing files are left untouched by [create].
  /// Calling [create] on an existing file still might fail if there are
  /// restrictive permissions on the file.
  ///
  /// Completes the future with a [FileSystemException] if the operation fails.
  Future<File> create({bool recursive = false, bool exclusive = false});

  /// Synchronously creates the file.
  ///
  /// If [recursive] is `false`, the default, the file is created
  /// only if all directories in its path already exist.
  /// If [recursive] is `true`, all non-existing parent paths are created first.
  ///
  /// If [exclusive] is `true` and to-be-created file already exists, this
  /// operation completes the future with a [FileSystemException].
  ///
  /// If [exclusive] is `false`, existing files are left untouched by
  /// [createSync]. Calling [createSync] on an existing file still might fail
  /// if there are restrictive permissions on the file.
  ///
  /// Throws a [FileSystemException] if the operation fails.
  void createSync({bool recursive = false, bool exclusive = false});

  /// Renames this file.
  ///
  /// Returns a `Future<File>` that completes
  /// with a [File] for the renamed file.
  ///
  /// If [newPath] is a relative path, it is resolved against
  /// the current working directory ([Directory.current]).
  /// This means that simply changing the name of a file,
  /// but keeping it the original directory,
  /// requires creating a new complete path with the new name
  /// at the end. Example:
  /// ```dart
  /// Future<File> changeFileNameOnly(File file, String newFileName) {
  ///   var path = file.path;
  ///   var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  ///   var newPath = path.substring(0, lastSeparator + 1) + newFileName;
  ///   return file.rename(newPath);
  /// }
  /// ```
  /// On some platforms, a rename operation cannot move a file between
  /// different file systems. If that is the case, instead [copy] the
  /// file to the new location and then remove the original.
  ///
  /// If [newPath] identifies an existing file or link, that entity is
  /// removed first. If [newPath] identifies an existing directory, the
  /// operation fails and the future completes with a [FileSystemException].
  Future<File> rename(String newPath);

  /// Synchronously renames this file.
  ///
  /// Returns a [File] for the renamed file.
  ///
  /// If [newPath] is a relative path, it is resolved against
  /// the current working directory ([Directory.current]).
  /// This means that simply changing the name of a file,
  /// but keeping it the original directory,
  /// requires creating a new complete path with the new name
  /// at the end. Example:
  /// ```dart
  /// File changeFileNameOnlySync(File file, String newFileName) {
  ///   var path = file.path;
  ///   var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  ///   var newPath = path.substring(0, lastSeparator + 1) + newFileName;
  ///   return file.renameSync(newPath);
  /// }
  /// ```
  /// On some platforms, a rename operation cannot move a file between
  /// different file systems. If that is the case, instead [copySync] the
  /// file to the new location and then [deleteSync] the original.
  ///
  /// If [newPath] identifies an existing file or link, that entity is
  /// removed first. If [newPath] identifies an existing directory the
  /// operation throws a [FileSystemException].
  File renameSync(String newPath);

  /// Copies this file.
  ///
  /// If [newPath] is a relative path, it is resolved against
  /// the current working directory ([Directory.current]).
  ///
  /// Returns a `Future<File>` that completes
  /// with a [File] for the copied file.
  ///
  /// If [newPath] identifies an existing file, that file is
  /// removed first. If [newPath] identifies an existing directory, the
  /// operation fails and the future completes with an exception.
  Future<File> copy(String newPath);

  /// Synchronously copies this file.
  ///
  /// If [newPath] is a relative path, it is resolved against
  /// the current working directory ([Directory.current]).
  ///
  /// Returns a [File] for the copied file.
  ///
  /// If [newPath] identifies an existing file, that file is
  /// removed first. If [newPath] identifies an existing directory the
  /// operation fails and an exception is thrown.
  File copySync(String newPath);

  /// The length of the file.
  ///
  /// Returns a `Future<int>` that completes with the length in bytes.
  Future<int> length();

  /// The length of the file provided synchronously.
  ///
  /// Throws a [FileSystemException] if the operation fails.
  int lengthSync();

  /// A [File] with the absolute path of [path].
  ///
  /// The absolute path is computed by prefixing
  /// a relative path with the current working directory,
  /// or returning an absolute path unchanged.
  File get absolute;

  /// The last-accessed time of the file.
  ///
  /// Returns a `Future<DateTime>` that completes with the date and time when the
  /// file was last accessed, if the information is available.
  ///
  /// Throws a [FileSystemException] if the operation fails.
  Future<DateTime> lastAccessed();

  /// The last-accessed time of the file.
  ///
  /// Returns the date and time when the file was last accessed,
  /// if the information is available. Blocks until the information can be returned
  /// or it is determined that the information is not available.
  ///
  /// Throws a [FileSystemException] if the operation fails.
  DateTime lastAccessedSync();

  /// Modifies the time the file was last accessed.
  ///
  /// Returns a [Future] that completes once the operation has completed.
  ///
  /// Throws a [FileSystemException] if the time cannot be set.
  Future setLastAccessed(DateTime time);

  /// Synchronously modifies the time the file was last accessed.
  ///
  /// Throws a [FileSystemException] if the time cannot be set.
  void setLastAccessedSync(DateTime time);

  /// Get the last-modified time of the file.
  ///
  /// Returns a `Future<DateTime>` that completes with the date and time when the
  /// file was last modified, if the information is available.
  ///
  /// Throws a [FileSystemException] if the operation fails.
  Future<DateTime> lastModified();

  /// Get the last-modified time of the file.
  ///
  /// Returns the date and time when the file was last modified,
  /// if the information is available. Blocks until the information can be returned
  /// or it is determined that the information is not available.
  ///
  /// Throws a [FileSystemException] if the operation fails.
  DateTime lastModifiedSync();

  /// Modifies the time the file was last modified.
  ///
  /// Returns a [Future] that completes once the operation has completed.
  ///
  /// Throws a [FileSystemException] if the time cannot be set.
  Future setLastModified(DateTime time);

  /// Synchronously modifies the time the file was last modified.
  ///
  /// If the attributes cannot be set, throws a [FileSystemException].
  void setLastModifiedSync(DateTime time);

  /// Opens the file for random access operations.
  ///
  /// Returns a `Future<RandomAccessFile>` that completes with the opened
  /// random access file. [RandomAccessFile]s must be closed using the
  /// [RandomAccessFile.close] method.
  ///
  /// Files can be opened in three modes:
  ///
  /// * [FileMode.read]: open the file for reading.
  ///
  /// * [FileMode.write]: open the file for both reading and writing and
  /// truncate the file to length zero. If the file does not exist the
  /// file is created.
  ///
  /// * [FileMode.append]: same as [FileMode.write] except that the file is
  /// not truncated.
  ///
  /// Throws a [FileSystemException] if the operation fails.
  // Future<RandomAccessFile> open({FileMode mode = FileMode.read});

  /// Synchronously opens the file for random access operations.
  ///
  /// The result is a [RandomAccessFile] on which random access operations
  /// can be performed. Opened [RandomAccessFile]s must be closed using
  /// the [RandomAccessFile.close] method.
  ///
  /// See [open] for information on the [mode] argument.
  ///
  /// Throws a [FileSystemException] if the operation fails.
  // RandomAccessFile openSync({FileMode mode = FileMode.read});

  /// Creates a new independent [Stream] for the contents of this file.
  ///
  /// If [start] is present, the file will be read from byte-offset [start].
  /// Otherwise from the beginning (index 0).
  ///
  /// If [end] is present, only bytes up to byte-index [end] will be read.
  /// Otherwise, until end of file.
  ///
  /// In order to make sure that system resources are freed, the stream
  /// must be read to completion or the subscription on the stream must
  /// be cancelled.
  ///
  /// If [File] is a [named pipe](https://en.wikipedia.org/wiki/Named_pipe)
  /// then the returned [Stream] will wait until the write side of the pipe
  /// is closed before signaling "done". If there are no writers attached
  /// to the pipe when it is opened, then [Stream.listen] will wait until
  /// a writer opens the pipe.
  Stream<List<int>> openRead([int? start, int? end]);

  /// Creates a new independent [IOSink] for the file.
  ///
  /// The [IOSink] must be closed when no longer used, to free
  /// system resources.
  ///
  /// An [IOSink] for a file can be opened in two modes:
  ///
  /// * [FileMode.write]: truncates the file to length zero.
  /// * [FileMode.append]: sets the initial write position to the end
  ///   of the file.
  ///
  ///  When writing strings through the returned [IOSink] the encoding
  ///  specified using [encoding] will be used. The returned [IOSink]
  ///  has an `encoding` property which can be changed after the
  ///  [IOSink] has been created.
  ///
  /// The returned [IOSink] does not transform newline characters (`"\n"`) to
  /// the platform's conventional line ending (e.g. `"\r\n"` on Windows). Write
  /// a [Platform.lineTerminator] if a platform-specific line ending is needed.
  // IOSink openWrite({FileMode mode = FileMode.write, Encoding encoding = utf8});

  /// Reads the entire file contents as a list of bytes.
  ///
  /// Returns a `Future<Uint8List>` that completes with the list of bytes that
  /// is the contents of the file.
  Future<Uint8List> readAsBytes();

  /// Synchronously reads the entire file contents as a list of bytes.
  ///
  /// Throws a [FileSystemException] if the operation fails.
  Uint8List readAsBytesSync();

  /// Reads the entire file contents as a string using the given
  /// [Encoding].
  ///
  /// Returns a `Future<String>` that completes with the string once
  /// the file contents has been read.
  Future<String> readAsString({Encoding encoding = utf8});

  /// Synchronously reads the entire file contents as a string using the
  /// given [Encoding].
  ///
  /// Throws a [FileSystemException] if the operation fails.
  String readAsStringSync({Encoding encoding = utf8});

  /// Reads the entire file contents as lines of text using the given
  /// [Encoding].
  ///
  /// Returns a `Future<List<String>>` that completes with the lines
  /// once the file contents has been read.
  Future<List<String>> readAsLines({Encoding encoding = utf8});

  /// Synchronously reads the entire file contents as lines of text
  /// using the given [Encoding].
  ///
  /// Throws a [FileSystemException] if the operation fails.
  List<String> readAsLinesSync({Encoding encoding = utf8});

  /// Writes a list of bytes to a file.
  ///
  /// Opens the file, writes the list of bytes to it, and closes the file.
  /// Returns a `Future<File>` that completes with this [File] object once
  /// the entire operation has completed.
  ///
  /// By default [writeAsBytes] creates the file for writing and truncates the
  /// file if it already exists. In order to append the bytes to an existing
  /// file, pass [FileMode.append] as the optional mode parameter.
  ///
  /// If the argument [flush] is set to `true`, the data written will be
  /// flushed to the file system before the returned future completes.
  Future<File> writeAsBytes(List<int> bytes,
      {FileMode mode = FileMode.write, bool flush = false});

  /// Synchronously writes a list of bytes to a file.
  ///
  /// Opens the file, writes the list of bytes to it and closes the file.
  ///
  /// By default [writeAsBytesSync] creates the file for writing and truncates
  /// the file if it already exists. In order to append the bytes to an existing
  /// file, pass [FileMode.append] as the optional mode parameter.
  ///
  /// If the [flush] argument is set to `true` data written will be
  /// flushed to the file system before returning.
  ///
  /// Throws a [FileSystemException] if the operation fails.
  void writeAsBytesSync(List<int> bytes,
      {FileMode mode = FileMode.write, bool flush = false});

  /// Writes a string to a file.
  ///
  /// Opens the file, writes the string in the given encoding, and closes the
  /// file. Returns a `Future<File>` that completes with this [File] object
  /// once the entire operation has completed.
  ///
  /// By default [writeAsString] creates the file for writing and truncates the
  /// file if it already exists. In order to append the bytes to an existing
  /// file, pass [FileMode.append] as the optional mode parameter.
  ///
  /// If the argument [flush] is set to `true`, the data written will be
  /// flushed to the file system before the returned future completes.
  ///
  /// This method does not transform newline characters (`"\n"`) to the
  /// platform conventional line ending (e.g. `"\r\n"` on Windows). Use
  /// [Platform.lineTerminator] to separate lines in [contents] if platform
  /// contentional line endings are needed.
  Future<File> writeAsString(String contents,
      {FileMode mode = FileMode.write,
      Encoding encoding = utf8,
      bool flush = false});

  /// Synchronously writes a string to a file.
  ///
  /// Opens the file, writes the string in the given encoding, and closes the
  /// file.
  ///
  /// By default [writeAsStringSync] creates the file for writing and
  /// truncates the file if it already exists. In order to append the bytes
  /// to an existing file, pass [FileMode.append] as the optional mode
  /// parameter.
  ///
  /// If the [flush] argument is set to `true`, data written will be
  /// flushed to the file system before returning.
  ///
  /// This method does not transform newline characters (`"\n"`) to the
  /// platform conventional line ending (e.g. `"\r\n"` on Windows). Use
  /// [Platform.lineTerminator] to separate lines in [contents] if platform
  /// contentional line endings are needed.
  ///
  /// Throws a [FileSystemException] if the operation fails.
  void writeAsStringSync(String contents,
      {FileMode mode = FileMode.write,
      Encoding encoding = utf8,
      bool flush = false});

  /// Get the path of the file.
  String get path;
}
