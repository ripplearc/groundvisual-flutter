import 'dart:core';

/// The basic modelyear like information about a machine.
/// [muid] is the machine unique identifier that is assigned uniquely
/// to each machine across accounts. [model], [year], and [brand] are the
/// specifications of a machine that never change. [nickname] is a friendly
/// name of a machine in an account, it is replaced with [model] + [year] is missing.
class MachineDetail {
  final String muid;
  final String model;
  final int year;
  final String brand;
  final String? nickName;

  MachineDetail(this.muid, this.model, this.year, this.brand, this.nickName);

  String get modelYear => model + " " + year.toString();
}
