import 'dart:async';

import 'crud_table_const.dart';
import 'form_item.dart';
import 'form_row.dart';
import 'form_section.dart';
import 'crud_table_data_model.dart';
import 'crud_table_row_holder.dart';
import 'package:fluid_kit/fluid_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:split_view/split_view.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// CRUD Table class
/// user have to provide CrudViewSource which have all the configurations and listeners

class CrudTableColumnSizeChangeNotifier extends ChangeNotifier {
  CrudTableColumnSizeChangeNotifier();
  void notify() {
    notifyListeners();
  }
}

class CrudTablePageNumberChangingNotifier extends StateNotifier<int> {
  CrudTablePageNumberChangingNotifier() : super(0);

  void setPage(int page) {
    state = page;
  }
}

class CrudTableTableDataNotifier<T>
    extends StateNotifier<CrudTableDataModel<T>> {
  CrudTableTableDataNotifier(CrudTableDataModel<T> state) : super(state);

  void setData(CrudTableDataModel<T> data) {
    state = data;
  }
}

class CrudTableCrudActionChangingNotifier extends ChangeNotifier {
  CrudAction crudAction;
  CrudTableCrudActionChangingNotifier(this.crudAction);

  void changeAction(CrudAction action) {
    crudAction = action;
    notifyListeners();
  }
}

enum CrudAction { init, refresh, add, edit, delete }

class Pagination {
  int pageNumber;
  int limit;

  Pagination({required this.pageNumber, required this.limit});

  @override
  String toString() {
    return 'Pagination{pageNumber: $pageNumber, limit: $limit}';
  }
}

class CrudTable<T> extends StatefulWidget {
  /// notify when user click on a row of the table
  ValueChanged<dynamic> onTap;
  CrudViewSource crudViewSource;

  AutoDisposeChangeNotifierProvider<CrudTableCrudActionChangingNotifier>
      crudActionChangeProvider = ChangeNotifierProvider.autoDispose(
          (ref) => CrudTableCrudActionChangingNotifier(CrudAction.init));

  var pageNumberChangeProvider = StateNotifierProvider.autoDispose(
      (ref) => CrudTablePageNumberChangingNotifier());
  var tableBodyRebuildNotifierProvider =
      ChangeNotifierProvider.autoDispose<CrudTableColumnSizeChangeNotifier>(
          (ref) => CrudTableColumnSizeChangeNotifier());
  var tableDataProvider = StateNotifierProvider.autoDispose(
      (ref) => CrudTableTableDataNotifier(CrudTableDataModel(isLoading: true)));

  CrudTable({required this.crudViewSource, required this.onTap});

  @override
  _CrudTableState createState() => _CrudTableState(
      crudActionChangeProvider,
      pageNumberChangeProvider,
      tableBodyRebuildNotifierProvider,
      tableDataProvider);
}

class _CrudTableState<T> extends State<CrudTable> {
  AutoDisposeChangeNotifierProvider<CrudTableCrudActionChangingNotifier>
      crudActionChangeProvider;
  var pageNumberChangeProvider;
  var tableBodyRebuildNotifierProvider;
  var tableDataProvider;

  late int currentPageKey;
  late bool _hasMore;
  late int _pageNumber;
  late int pageLimit;
  late bool _error;
  late bool _loading;

  late List<T> _tableBodyData;
  final int _nextPageThreshold = 5;

  late List<GlobalKey> headerKeys;
  late List<double> headerColumnSizes;
  late double headerColumnFullSize;
  late List<Widget> columnHeaderWidgets;

  final _formKey = GlobalKey<FormState>();
  T? workingDataObj;
  late var clickPos;
  bool refreshDueToListItemClick = false;
  bool refreshFormDueToMainSplitViewChange = false;
  bool canShowLastPageRefreshButton = false;

  List<FormSection> sections = [];

  List<Widget> formWidgets = [];

  _CrudTableState(this.crudActionChangeProvider, this.pageNumberChangeProvider,
      this.tableBodyRebuildNotifierProvider, this.tableDataProvider);

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
        provider: tableDataProvider,
        onChange: (context, data) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
            data as CrudTableDataModel<T>;
            canShowLastPageRefreshButton = false;
            if (data.isError != null && data.isError == true) {
              _loading = false;
              _error = true;
              context.read(tableBodyRebuildNotifierProvider).notify();
            } else if (data.isLoading != null && data.isLoading == true) {
              _loading = true;
              _error = false;
              context.read(tableBodyRebuildNotifierProvider).notify();
            } else if (data.data != null) {
              List<T> dataLs = data.data as List<T>;
              if (dataLs.isNotEmpty) {
                _hasMore = dataLs.length == widget.crudViewSource.pageLimit;
                _loading = false;
                _pageNumber = _pageNumber + 1;
                _tableBodyData.addAll(dataLs);
                context.read(tableBodyRebuildNotifierProvider).notify();
              } else {
                //TODO show end refresh button.
                canShowLastPageRefreshButton = true;
                _hasMore = false;
                _loading = false;
                context.read(tableBodyRebuildNotifierProvider).notify();
              }
            }
          });
        },
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SplitView(
              onWeightChanged: (value) {
                refreshFormDueToMainSplitViewChange = true;
                setState(() {});
              },
              indicator:
                  const SplitIndicator(viewMode: SplitViewMode.Horizontal),
              gripColor: Colors.grey.shade200,
              gripSize: 4,
              gripColorActive: Colors.grey.shade500,
              viewMode: SplitViewMode.Horizontal,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30,
                      child: LayoutBuilder(builder: (context, constraints) {
                        headerColumnFullSize = constraints.maxWidth;
                        return SplitView(
                          onWeightChanged: (value) {
                            headerColumnSizes.clear();
                            var it = value.iterator;
                            while (it.moveNext()) {
                              double? d = it.current;
                              headerColumnSizes.add(d!);
                            }
                            context
                                .read(tableBodyRebuildNotifierProvider)
                                .notify();
                          },
                          indicator: const SplitIndicator(
                              viewMode: SplitViewMode.Horizontal),
                          gripColor: Colors.grey.shade200,
                          gripSize: 4,
                          gripColorActive: Colors.grey.shade500,
                          viewMode: SplitViewMode.Horizontal,
                          children: columnHeaderWidgets.isNotEmpty
                              ? columnHeaderWidgets
                              : crateHeaders(headerColumnFullSize),
                        );
                      }),
                    ),
                    const Divider(
                      height: 0,
                    ),
                    Consumer(
                      builder: (context, watch, child) {
                        watch(tableBodyRebuildNotifierProvider);
                        return Expanded(child: createTableBody());
                      },
                    ),
                  ],
                ), // Table Section
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.refresh),
                                  splashRadius: 16,
                                  tooltip: "Refresh",
                                  // color: Colors.white,
                                  onPressed: () {
                                    setTableInitSettings();
                                    notifyPageChange(0);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  splashRadius: 16,
                                  tooltip: "Add New",
                                  // color: Colors.white,
                                  onPressed: () {
                                    refreshDueToListItemClick = true;
                                    clickPos = null;
                                    context
                                        .read(tableBodyRebuildNotifierProvider)
                                        .notify();
                                    workingDataObj =
                                        widget.crudViewSource.getEmptyEntity();
                                    context
                                        .read(crudActionChangeProvider.notifier)
                                        .changeAction(CrudAction.add);
                                  },
                                ),
                                IconButton(
                                  splashRadius: 16,
                                  icon: const Icon(Icons.delete),
                                  tooltip: "Delete",
                                  // color: Colors.white,
                                  onPressed: () {
                                    context
                                        .read(crudActionChangeProvider.notifier)
                                        .changeAction(CrudAction.delete);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ), // form action buttons container

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Consumer(
                          builder: (context, watch, child) {
                            final v =
                                watch(crudActionChangeProvider).crudAction;
                            return Form(
                                key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: v == CrudAction.init
                                    ? Container()
                                    : Column(
                                        children: [
                                          Column(
                                            children: widget.crudViewSource
                                                        .createForm !=
                                                    null
                                                ? createFormItems(
                                                    widget.crudViewSource,
                                                    workingDataObj!)
                                                : [],
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0, top: 32),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    OutlinedButton(
                                                      onPressed: () {
                                                        workingDataObj = widget
                                                            .crudViewSource
                                                            .getEmptyEntity();
                                                        context
                                                            .read(
                                                                crudActionChangeProvider
                                                                    .notifier)
                                                            .changeAction(
                                                                CrudAction
                                                                    .init);
                                                      },
                                                      child:
                                                          const Text("Cancel"),
                                                    ),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    ElevatedButton.icon(
                                                      icon: v ==
                                                              CrudAction.delete
                                                          ? const Icon(
                                                              Icons.delete,
                                                              size: 18)
                                                          : const Icon(
                                                              Icons
                                                                  .check_outlined,
                                                              size: 18),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: v ==
                                                                      CrudAction
                                                                          .delete
                                                                  ? Colors.red
                                                                  : null),
                                                      onPressed: () {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          _formKey.currentState!
                                                              .save();

                                                          if (widget
                                                                  .crudViewSource
                                                                  .crudActionListener !=
                                                              null) {
                                                            switch (v) {
                                                              case CrudAction
                                                                  .add:
                                                                {
                                                                  if (widget
                                                                          .crudViewSource
                                                                          .crudActionListener!
                                                                          .add !=
                                                                      null) {
                                                                    Future<
                                                                        T> d = widget
                                                                            .crudViewSource
                                                                            .crudActionListener!
                                                                            .add!(workingDataObj)
                                                                        as Future<
                                                                            T>;
                                                                    d.then(
                                                                        (value) {
                                                                      bool
                                                                          needToRefresh =
                                                                          false;
                                                                      if (_tableBodyData
                                                                          .isNotEmpty) {
                                                                        if (!_hasMore) {
                                                                          if (_tableBodyData.length >
                                                                              widget.crudViewSource.pageLimit) {
                                                                            var needToRemoveCount =
                                                                                _tableBodyData.length % widget.crudViewSource.pageLimit;
                                                                            int start =
                                                                                (_tableBodyData.length - needToRemoveCount) - 1;
                                                                            int end =
                                                                                _tableBodyData.length - 1;
                                                                            _tableBodyData.removeRange(start,
                                                                                end);
                                                                            _pageNumber =
                                                                                _pageNumber - 1;
                                                                          } else {
                                                                            _pageNumber =
                                                                                0;
                                                                            _tableBodyData.clear();
                                                                          }
                                                                          needToRefresh =
                                                                              true;
                                                                        }
                                                                      } else {
                                                                        _pageNumber =
                                                                            0;
                                                                        needToRefresh =
                                                                            true;
                                                                      }

                                                                      if (needToRefresh) {
                                                                        notifyPageChange(
                                                                            _pageNumber);
                                                                        context
                                                                            .read(crudActionChangeProvider.notifier)
                                                                            .changeAction(CrudAction.init);
                                                                      }
                                                                    }, onError:
                                                                            (e) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text('Adding fails! ${e.toString()}')));
                                                                    });
                                                                  }
                                                                }
                                                                break;
                                                              case CrudAction
                                                                  .edit:
                                                                {
                                                                  if (widget
                                                                          .crudViewSource
                                                                          .crudActionListener!
                                                                          .edit !=
                                                                      null) {
                                                                    Future? d = widget
                                                                        .crudViewSource
                                                                        .crudActionListener!
                                                                        .edit!(workingDataObj);
                                                                    assert(
                                                                        d !=
                                                                            null,
                                                                        'Edit method not returns null');
                                                                    d!.then(
                                                                      (value) {
                                                                        _tableBodyData[clickPos] =
                                                                            workingDataObj!;
                                                                        context
                                                                            .read(tableBodyRebuildNotifierProvider)
                                                                            .notify();
                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text('Edit success!')));
                                                                      },
                                                                      onError:
                                                                          (e) {
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content:
                                                                                Text('Edit fails! ${e.toString()}')));
                                                                      },
                                                                    );
                                                                  }
                                                                }
                                                                break;
                                                              case CrudAction
                                                                  .delete:
                                                                {
                                                                  if (widget
                                                                          .crudViewSource
                                                                          .crudActionListener!
                                                                          .delete !=
                                                                      null) {
                                                                    Future? d = widget
                                                                        .crudViewSource
                                                                        .crudActionListener!
                                                                        .delete!(workingDataObj);
                                                                    d.then(
                                                                      (value) {
                                                                        _tableBodyData.removeAt(clickPos
                                                                            as int);
                                                                        context
                                                                            .read(crudActionChangeProvider.notifier)
                                                                            .changeAction(CrudAction.init);
                                                                        context
                                                                            .read(tableBodyRebuildNotifierProvider)
                                                                            .notify();
                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text('Delete success!')));
                                                                      },
                                                                      onError:
                                                                          (e) {
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content:
                                                                                Text('Delete fails! ${e.toString()}')));
                                                                      },
                                                                    );
                                                                  }
                                                                }
                                                                break;
                                                            }
                                                          }
                                                          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                                                        }
                                                      },
                                                      label: Text(
                                                          getActionBtnText(v)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ));
                          },
                        ),
                      )
                    ],
                  ),
                ), // Form section
              ],
            )));
  }

  List<Widget> crateHeaders(double headerColumnFullSize) {
    bool initValEmpty = false;
    late double initRatio;
    if (headerColumnSizes.isEmpty) {
      initValEmpty = true;
      initRatio = 1 / widget.crudViewSource.columns.length;
    }

    List<Widget> columnWidgets = [];
    for (String s in widget.crudViewSource.columns) {
      GlobalKey k = GlobalKey();
      headerKeys.add(k);
      if (initValEmpty) headerColumnSizes.add(initRatio);

      columnWidgets.add(
        Container(
          color: Colors.white,
          key: k,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                s,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
    }
    return columnWidgets;
  }

  List<Widget> createFormItems(CrudViewSource source, T workingDataObj) {
    if (!refreshFormDueToMainSplitViewChange) {
      sections.clear();
      formWidgets.clear();
      sections = source.createForm!(workingDataObj);
      int sectionCount = 0;
      for (FormSection s in sections) {
        sectionCount++;
        if (s.sectionTitle != null) {
          formWidgets.add(Padding(
            padding: sectionCount == 1
                ? const EdgeInsets.only(bottom: 24.0)
                : const EdgeInsets.only(top: 24, bottom: 24.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(s.sectionTitle.toString())),
          ));
        }

        List<FormRow> rows = s.formRows!();
        for (FormRow r in rows) {
          List<FormItem> items = r.formItems();
          List<Fluidable> fItem = [];
          for (FormItem i in items) {
            fItem.add(Fluidable(
              fluid: i.ratio,
              // minWidth: 100,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: i.item,
              ),
            ));
          }

          formWidgets.add(Fluid(
            children: fItem,
          ));
        }
      }
    } else {
      refreshFormDueToMainSplitViewChange = false;
    }

    return formWidgets;
  }

  Widget createTableBody() {
    if (_tableBodyData.isEmpty) {
      if (_loading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              notifyPageChange(0);
            });
          },
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Error while loading photos, tap to try again"),
          ),
        ));
      }
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
                controller: ScrollController(keepScrollOffset: true),
                itemCount: _tableBodyData.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _tableBodyData.length - _nextPageThreshold &&
                      _hasMore) {
                    // if (!refreshDueToListItemClick) {
                    notifyPageChange(_pageNumber);
                    // }
                    refreshDueToListItemClick = false;
                  }
                  if (index == _tableBodyData.length) {
                    if (_error) {
                      return Center(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            _loading = true;
                            _error = false;
                            notifyPageChange(_pageNumber);
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                              "Error while loading photos, tap to try again"),
                        ),
                      ));
                    } else {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      ));
                    }
                  }
                  final T data = _tableBodyData[index];
                  var w = widget.crudViewSource.createRows(data, index);

                  List<Widget> r = [];
                  double left = 0;
                  int a = 0;

                  // without this row stack will crash.  (setting row a size )
                  r.add(Container(
                    height: widget.crudViewSource.rowHeight,
                  ));

                  for (Widget wi in w) {
                    double weight = headerColumnSizes[a];
                    r.add(Positioned.fill(
                        left: left,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          color: clickPos != null && clickPos == index
                              ? CrudTableConst.SELECTED_ITEM_COLOR
                              : Colors.white,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: ClipRect(child: wi),
                              )),
                        )));
                    left += (headerColumnFullSize * weight);
                    a++;
                  }

                  return VisibilityDetector(
                    key: Key(index.toString()),
                    onVisibilityChanged: (visibilityInfo) {
                      if (index == _tableBodyData.length - 1) {
                        canShowLastPageRefreshButton = true;
                        context.read(tableBodyRebuildNotifierProvider).notify();
                      } else {
                        canShowLastPageRefreshButton = false;
                      }
                    },
                    child: LayoutBuilder(builder: (context, constraint) {
                      return InkWell(
                        onTap: () {
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(index.toString())));
                          workingDataObj = data;
                          context
                              .read(crudActionChangeProvider.notifier)
                              .changeAction(CrudAction.edit);
                          widget.onTap(data);

                          if (clickPos != null && clickPos == index) {
                            clickPos = null;
                            context
                                .read(crudActionChangeProvider.notifier)
                                .changeAction(CrudAction.init);
                          } else {
                            clickPos = index;
                          }
                          refreshDueToListItemClick = true;
                          context
                              .read(tableBodyRebuildNotifierProvider)
                              .notify();
                        },
                        child: Container(
                            color: clickPos != null && clickPos == index
                                ? Colors.lightBlue.shade100
                                : Colors.white,
                            child: Column(
                              children: [
                                Stack(
                                  children: r,
                                ),
                                const Divider(
                                  height: 0,
                                )
                              ],
                            )),
                      );
                    }),
                  );
                }),
          ),
          canShowLastPageRefreshButton
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextButton.icon(
                    onPressed: () {
                      notifyPageChange(_pageNumber);
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text("Check for new Data"),
                  ),
                )
              : Container()
        ],
      );
    }
    return Container();
  }

  String getActionBtnText(v) {
    if (v == CrudAction.edit) {
      return "Update";
    } else if (v == CrudAction.delete) {
      return "Delete";
    } else {
      return "Submit";
    }
  }

  @override
  void initState() {
    columnHeaderWidgets = [];
    headerColumnSizes = [];
    headerKeys = [];
    // columnHeaderWidgets = crateHeaders();
    setTableInitSettings(); // reset

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      for (GlobalKey k in headerKeys) {
        headerColumnSizes.add(k.currentContext!.size!.width);
      }
      notifyPageChange(0);
    });
    super.initState();
  }

  notifyPageChange(int page) {
    Future<List> data = widget.crudViewSource.onPageChange(
        Pagination(pageNumber: page, limit: widget.crudViewSource.pageLimit));
    data.then(
      (value) => {
        context
            .read(tableDataProvider.notifier)
            .setData(CrudTableDataModel(data: value))
      },
      onError: (r) {
        context
            .read(tableDataProvider.notifier)
            .setData(CrudTableDataModel(isError: true));
      },
    );
  }

  setTableInitSettings() {
    _hasMore = true;
    _pageNumber = 0;
    // ignore: unnecessary_null_comparison
    pageLimit = widget.crudViewSource.pageLimit != null &&
            widget.crudViewSource.pageLimit != 0
        ? widget.crudViewSource.pageLimit
        : 20;
    _error = false;
    _loading = true;
    _tableBodyData = [];
    workingDataObj = widget.crudViewSource.getEmptyEntity();
    clickPos = null;
  }
}
