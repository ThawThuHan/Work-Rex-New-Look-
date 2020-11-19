import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:workrex/code_models/rate_modal.dart';
import 'package:workrex/custom_widget/progress_hub.dart';
import 'package:workrex/services/rate_database.dart';

class RateModalBottom extends StatefulWidget {
  final String subjectId;
  final String subjectName;
  final String objectId;
  final String objectName;

  RateModalBottom({
    this.subjectId,
    this.subjectName,
    this.objectId,
    this.objectName,
  });

  @override
  _RateModalBottomState createState() => _RateModalBottomState();
}

class _RateModalBottomState extends State<RateModalBottom> {
  final PageController _pageController = PageController();

  final RateModel _rateModel = RateModel();
  bool _isAsyncCall = false;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: _isAsyncCall,
      child: Container(
        color: Color(0x737373).withOpacity(0.8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                Text(
                  'Help ${widget.objectName} Improve!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'ကောင်းသည်ဖြစ်စေ၊ ဆိုးသည်ဖြစ်စေ ကျွန်ုပ်အပေါ် သင်ကြိုက်နှစ်သက်သလို သတ်မှတ်ပေးနိုင်ပါသည်။ ကျေးဇူးတင်ပါသည်။',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Divider(
                  thickness: 2.5,
                ),
                Text(
                  '1/4',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: PageView(
                      controller: _pageController,
                      children: [
                        buildRateColumn(
                          context,
                          label:
                              'ကျွန်ုပ်၏ Performance အပေါ် Rate သတ်မှတ်ပေးပါ',
                          onRated: (double rate) {
                            _rateModel.performance = rate;
                          },
                        ),
                        buildRateColumn(
                          context,
                          label:
                              'ကျွန်ုပ်၏ လူမှုဆက်ဆံရေးအပေါ် Rate သတ်မှတ်ပေးပါ',
                          onRated: (double rate) {
                            _rateModel.personality = rate;
                          },
                        ),
                        buildRateColumn(
                          context,
                          label:
                              'ကျွန်ုပ်၏ ဗဟုသုတရှိမှု အပေါ် Rate သတ်မှတ်ပေးပါ',
                          onRated: (double rate) {
                            _rateModel.knowledge = rate;
                          },
                        ),
                        buildRateColumn(
                          context,
                          label:
                              'ကျွန်ုပ်၏ အသင်းလိုက်ပူးပေါင်းလုပ်ဆောင်နိုင်မှု အပေါ် Rate သတ်မှတ်ပေးပါ',
                          onRated: (double rate) {
                            _rateModel.teamwork = rate;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                index >= 3
                    ? RaisedButton(
                        onPressed: () async {
                          setState(() {
                            _isAsyncCall = true;
                          });
                          print(_rateModel.performance);
                          print(_rateModel.personality);
                          print(_rateModel.knowledge);
                          print(_rateModel.teamwork);
                          await RateService.saveRate(widget.objectName,
                              widget.subjectId, 'performance', {
                            'rate': _rateModel.performance,
                            'subject': widget.subjectName,
                            'subjectId': widget.subjectId,
                          });
                          await RateService.saveRate(widget.objectName,
                              widget.subjectId, 'personality', {
                            'rate': _rateModel.personality,
                            'subject': widget.subjectName,
                            'subjectId': widget.subjectId,
                          });
                          await RateService.saveRate(widget.objectName,
                              widget.subjectId, 'knowledge', {
                            'rate': _rateModel.knowledge,
                            'subject': widget.subjectName,
                            'subjectId': widget.subjectId,
                          });
                          await RateService.saveRate(
                              widget.objectName, widget.subjectId, 'teamwork', {
                            'rate': _rateModel.teamwork,
                            'subject': widget.subjectName,
                            'subjectId': widget.subjectId,
                          });
                          await RateService.overallRate(
                              widget.objectName, widget.objectId);
                          setState(() {
                            _isAsyncCall = false;
                            Navigator.pop(context);
                          });
                        },
                        child: Text('done'),
                      )
                    : RaisedButton(
                        onPressed: () {
                          setState(() {
                            index++;
                          });
                          _pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text('Rate'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildRateColumn(BuildContext context,
      {String label, Function onRated}) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SmoothStarRating(
          size: 55,
          onRated: onRated,
          isReadOnly: false,
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          defaultIconData: Icons.star_border,
          borderColor: Theme.of(context).accentColor,
          color: Theme.of(context).accentColor,
          starCount: 5,
          allowHalfRating: true,
        )
      ],
    );
  }
}
