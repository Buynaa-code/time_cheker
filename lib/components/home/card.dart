import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_cheker/bloc/auth_bloc.dart';
import 'package:time_cheker/components/home/dropDown.dart';
import 'package:time_cheker/const/colors.dart';
import 'package:time_cheker/const/text_field.dart';
import 'package:time_cheker/service/app/di.dart';
import 'package:time_cheker/service/model/date_info.dart';
import 'package:time_cheker/service/model/member_model.dart';
import 'package:time_cheker/service/model/arrive_check.dart';
import 'package:logger/logger.dart';
import 'package:time_cheker/service/repository/repository.dart';

final Logger loggerPretty = Logger();

class Cart extends StatefulWidget {
  final DateInfo? selectedDateInfo; // Сонгосон огноог хадгалах

  const Cart({
    super.key,
    required this.selectedDateInfo,
  });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final Repository _repository = instance<Repository>();
  Map<int, bool> memberStatus = {};

  @override
  void didUpdateWidget(Cart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the selectedDateInfo has changed, clear the member status
    if (oldWidget.selectedDateInfo != widget.selectedDateInfo) {
      setState(() {
        memberStatus.clear();
      });
    }
  }

  Future<void> _irsenIreegui(Member member) async {
    if (widget.selectedDateInfo == null) {
      _showSnackBar(context, 'Огноо сонгоогүй байна!', false);
      return;
    }

    final String irsenIreegui = memberStatus[member.id] == true ? '0' : '1';
    final ArriveCheck arriveCheck = ArriveCheck(
      value: irsenIreegui,
      itgegchId: member.id,
      ognoo: widget.selectedDateInfo!.date, // Сонгосон огноо
    );

    print(
        '📝 Хэрэглэгч: ${member.ner} | ID: ${member.id} | Ирсэн: ${irsenIreegui == "1" ? "Тийм" : "Үгүй"} | Огноо: ${arriveCheck.ognoo}');

    try {
      await _repository.sendArrival(arriveCheck);
      _showSnackBar(context, 'Амжилттай илгээлээ.', true);
    } catch (e) {
      _showSnackBar(context, 'Явцад алдаа гарлаа.', false);
    }
  }

  void _showSnackBar(BuildContext context, String message, bool isSuccess) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? successColor4 : dangerColor5,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is MeInfoLoaded) {
                List<Member> members = state.memberList;

                if (members.isEmpty) {
                  return const Center(
                    child: Text(
                      "Хоосон байна",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    var member = members[index];
                    bool isArrived = member.irts == 1;

                    return Card(
                      color: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.blueAccent,
                          backgroundImage: member.zurag != null &&
                                  member.zurag!.isNotEmpty
                              ? NetworkImage(
                                  "https://office.jbch.mkh.mn/storage/${member.zurag}")
                              : null,
                          child: (member.zurag == null || member.zurag!.isEmpty)
                              ? const Icon(Icons.person,
                                  color: whiteColor, size: 48)
                              : null,
                        ),
                        title: Text(member.ner,
                            style:
                                ktsBodyLargeBold.copyWith(color: greyColor8)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member.utas ?? "Утасны дугаар байхгүй",
                                style:
                                    ktsBodyRegular.copyWith(color: greyColor5)),
                            Text(
                              (memberStatus[member.id] ?? isArrived)
                                  ? 'Ирсэн'
                                  : 'Ирээгүй',
                              style: ktsBodySmallBold.copyWith(
                                color: (memberStatus[member.id] ?? isArrived)
                                    ? successColor4
                                    : dangerColor5,
                              ),
                            ),
                          ],
                        ),
                        trailing: Switch(
                          value: memberStatus[member.id] ?? isArrived,
                          onChanged: (value) {
                            if (widget.selectedDateInfo == null) {
                              _showDateSelectionDialog();
                            } else {
                              setState(() {
                                memberStatus[member.id] = value;
                              });
                              _irsenIreegui(member);
                            }
                          },
                          activeColor: successColor4,
                          inactiveThumbColor: dangerColor5,
                          inactiveTrackColor: dangerColor5.withOpacity(0.3),
                          activeTrackColor: successColor4.withOpacity(0.3),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  void _showDateSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Анхааруулга"),
          content: const Text("Та эхлээд огноо сонгоно уу."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("ОК"),
            ),
          ],
        );
      },
    );
  }
}
