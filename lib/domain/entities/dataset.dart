import 'package:equatable/equatable.dart';

enum DatasetType { image, text, mixed }

enum DatasetStatus { pending, uploading, ready, error }

class Dataset extends Equatable {
  final String id;
  final String name;
  final String path;
  final DatasetType type;
  final DatasetStatus status;
  final int fileCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? errorMessage;

  const Dataset({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    required this.status,
    required this.fileCount,
    required this.createdAt,
    this.updatedAt,
    this.errorMessage,
  });

  Dataset copyWith({
    String? id,
    String? name,
    String? path,
    DatasetType? type,
    DatasetStatus? status,
    int? fileCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? errorMessage,
  }) {
    return Dataset(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      status: status ?? this.status,
      fileCount: fileCount ?? this.fileCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory Dataset.fromJson(Map<String, dynamic> json) {
    return Dataset(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      type: DatasetType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DatasetType.mixed,
      ),
      status: DatasetStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DatasetStatus.pending,
      ),
      fileCount: json['file_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      errorMessage: json['error_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'type': type.name,
      'status': status.name,
      'file_count': fileCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'error_message': errorMessage,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    path,
    type,
    status,
    fileCount,
    createdAt,
    updatedAt,
    errorMessage,
  ];
}
