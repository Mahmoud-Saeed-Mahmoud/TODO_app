import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;

  const NotificationScreen({super.key, required this.payload});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late String _payload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.colorScheme.surface,
        centerTitle: true,
        title: Text(
          _payload.split('|')[0],
          style: TextStyle(color: Get.isDarkMode ? Colors.white : darkGreyClr),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Get.isDarkMode ? Colors.white : darkGreyClr,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Hi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: primaryClr,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.text_format_rounded,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Title',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _payload.split('|')[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Icon(
                            Icons.description_rounded,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Description',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _payload.split('|')[1],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Date',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _payload.split('|')[2],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _payload = widget.payload;
  }
}
