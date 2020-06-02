import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mailapp/database/db_provider.dart';
import 'package:mailapp/models/mail.dart';
import 'package:mailapp/pages/create.dart';
import 'package:mailapp/pages/description.dart';
import 'package:sqflite/sqlite_api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DbProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        Navigator.of(context).pushNamed('/create');
        }, 
        child: Icon(Icons.add)
      ),
      body: FutureBuilder<List<Mail>>(
        future: dbProvider.getAllMails(),
        builder: (_, AsyncSnapshot<List<Mail>> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error.toString()),
            );
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          var mails = snapshot.data;
          if (mails.length == 0)
            return Center(
              child: const Text('No records'),
            );

          return ListView.builder(
              itemCount: mails.length,
              itemBuilder: (_, int index) {
                var item = mails[index];
                return Dismissible(
                  key: ObjectKey(item.id),
                  background: Container(
                    padding: EdgeInsets.only(right:3),
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.delete, color:Colors.white),
                    ],)
                  ),
                  child: Card(
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.red,
                        child: CircleAvatar(
                          radius:17,
                          backgroundColor: Colors.yellow,
                          child: Text(
                            item.from[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ),
                        title: Text(
                          item.from,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                        subtitle: Text(
                          item.subject,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Column(
                          children: <Widget>[
                            Text(item.date.substring(0,12)),
                            Expanded(
                              child: IconButton(icon: 
                              item.isFavourite ? Icon(Icons.star, color: Colors.yellow) : Icon(Icons.star_border), onPressed: (){
                                setState(() {
                                  item.isFavourite=!item.isFavourite;
                                  updateFav(mails[index]); 
                                });
                              }) 
                            ),
                          ],
                        ),
                        onTap: (){
                          showDetail(item);
                        },
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

