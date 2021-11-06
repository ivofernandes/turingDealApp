import 'package:flutter/material.dart';

class IconForLanguage extends StatelessWidget{
  final String language;
  const IconForLanguage(this.language);

  @override
  Widget build(BuildContext context) {

    String country = language;
    if(language == 'en'){
      country = 'gb-nir';
    }else if(language == 'sv'){
      country = 'se';
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.125),
            blurRadius: 1.0,
            spreadRadius: 0.0,
            offset: Offset(2, 3),
          )],
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: Image.asset(
                  'icons/flags/png/$country.png',
                  package: 'country_icons').image

          )
      ),
    );
  }
}