
class facultyModel{

  late String fac_name;
  late String fac_psrn;
  late String fac_address;
  late String fac_phone;
  late String fac_email;
  late String fac_block;
  late String fac_block_note;

  facultyModel({required this.fac_address,required this.fac_email,required this.fac_name,
                required this.fac_phone,required this.fac_psrn,required this.fac_block, required this.fac_block_note});

  factory facultyModel.fromDB(dynamic obj){
    return facultyModel(
        fac_address: obj["address"],
        fac_email: obj["email"],
        fac_name: obj["name"],
        fac_phone: obj["phone"],
        fac_psrn: obj["psrn"],
        fac_block: obj["block"],
        fac_block_note: obj["block_note"]
    );
  }

}
