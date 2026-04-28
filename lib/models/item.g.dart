
part of 'item.dart';


class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 0;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();

    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };

    return Item(
      id: fields[0] as String,
      title: fields[1] as String,
      image: fields[2] as String?,
      price: (fields[3] as num).toDouble(),
      mrpPrice: (fields[4] as num?)?.toDouble() ??
          (fields[3] as num).toDouble(),
      stock: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(6)

      ..writeByte(0)
      ..write(obj.id)

      ..writeByte(1)
      ..write(obj.title)

      ..writeByte(2)
      ..write(obj.image)

      ..writeByte(3)
      ..write(obj.price)

      ..writeByte(4)
      ..write(obj.mrpPrice)

      ..writeByte(5)
      ..write(obj.stock);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}