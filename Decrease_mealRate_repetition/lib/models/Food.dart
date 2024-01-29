class Food{
  String sname;
  String fname;
  String meat;
  DateTime date;
  double rate = 1.0;
  bool allergic = false;
  String img='';

  Food({required this.sname,required this.fname,required this.meat,required this.date,this.img = ''});
  @override
  String toString() => "sname:{$sname},fname:{$fname},meat:{$meat},date:{$date},img:{$img}";
}