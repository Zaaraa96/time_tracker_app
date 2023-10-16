import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common_widgets/list_items_builder.dart';
import '../../../../localization.dart';
import '../bloc/entries_bloc.dart';
import 'entries_list_tile.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Entries')),
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context, listen: false);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return ListItemsBuilder<EntriesListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) => EntriesListTile(model: model),
        );
      },
    );
  }
}
