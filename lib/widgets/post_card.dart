import 'package:clicli_dark/pages/player_page.dart';
import 'package:clicli_dark/utils/reg_utils.dart';
import 'package:clicli_dark/widgets/loading2load.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostCard extends StatelessWidget {
  final Map data;

  PostCard(this.data);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return PlayerPage(data: data);
        }), (Route<dynamic> route) => true);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).accentColor.withOpacity(0.2),
              offset: Offset(1, 1),
              blurRadius: 2,
            )
          ],
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: getSuo(data['content']),
              placeholder: (ctx, url) => SizedBox(
                height: 115,
                width: double.infinity,
                child: Center(child: loadingWidget),
              ),
              height: 115,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => SizedBox(
                height: 115,
                width: double.infinity,
                child: Center(child: Icon(Icons.error_outline)),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      data['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    data['tag'].substring(1).replaceAll(' ', ' · '),
                    style: Theme.of(context).textTheme.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Grid2RowView extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final ScrollController controller;
  final int len;

  Grid2RowView({
    @required this.itemBuilder,
    @required this.len,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 5, 8, 8),
                child: itemBuilder(ctx, i * 2),
              ),
            ),
            len > i * 2 + 1
                ? Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8, 5, 15, 8),
                      child: itemBuilder(ctx, i * 2 + 1),
                    ),
                  )
                : Expanded(child: Container())
          ],
        );
      },
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(0),
      itemCount: len % 2 > 0 ? len ~/ 2 + 1 : len ~/ 2,
      controller: controller,
    );
  }
}
