class CarouselIntro {
  String imgUrl;
  String quote;

  CarouselIntro.withData(this.imgUrl, this.quote);

  CarouselIntro();

  List<CarouselIntro> getDefaultValue() {
    return [
      CarouselIntro.withData(
          'assets/images/easy_setup.png', 'Instalasi dengan mudah.'),
      CarouselIntro.withData(
          'assets/images/multiplatform.png', 'Multiplatform'),
      CarouselIntro.withData('assets/images/reciept.png', 'Cetak Struk'),
      CarouselIntro.withData(
          'assets/images/report.png', 'Export Laporan ke Excel.'),
    ];
  }
}
