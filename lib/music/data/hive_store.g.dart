// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_store.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteAdapter extends TypeAdapter<Favourite> {
  @override
  final int typeId = 0;

  @override
  Favourite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favourite()
      ..title = fields[0] as String?
      ..authur = fields[1] as String?
      ..songUrl = fields[2] as String?
      ..imgUrl = fields[3] as String?
      ..id = fields[4] as String?;
  }

  @override
  void write(BinaryWriter writer, Favourite obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.authur)
      ..writeByte(2)
      ..write(obj.songUrl)
      ..writeByte(3)
      ..write(obj.imgUrl)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
