import 'package:dio_practice_project/constants/app_list.dart';
import 'package:dio_practice_project/features/Home/presentation/widgets/practice_card.dart';
import 'package:dio_practice_project/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text('Home Screen',style: TextStyle(
          color: Colors.white,
          fontSize: 20
        ),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppList.learningList.length,
              itemBuilder: (context,index){
                var data = AppList.learningList[index];
              return PracticeCard(
              onTap: (){
                Get.toNamed(data.routingConstant);
              },
              serialNumber: data.serialNumber,
              title: data.title,
            );
            }),
        
          ],
        ),
      ),
    );
  }
}