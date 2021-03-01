import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/component/site/site_dropdown_list.dart';

AppBar buildLandingHomePageTabletHeader() => AppBar(
      title: Text('Cresent Blvd', style: TextStyle(color: Colors.black)),
      leading: SiteDropDownList(),
      backgroundColor: Colors.white,
    );
