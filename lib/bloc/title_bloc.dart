import 'package:beanseditor/models/index.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class TitleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TitleFocused extends TitleEvent {}

class TitleUnfocused extends TitleEvent {}

abstract class TitleState extends Equatable {
  const TitleState();

  @override
  List<Object> get props => [];
}

class TitleWidget extends TitleState {
  final int focused;

  const TitleWidget({this.focused});

  TitleWidget copyWith({int focused}) {
    return TitleWidget(focused: focused ?? this.focused);
  }

  @override
  List<Object> get props => [focused];
}

class TitleBloc extends Bloc<TitleEvent, TitleState> {
  TitleBloc() : super(TitleWidget(focused: 0));

  @override
  Stream<TitleState> mapEventToState(TitleEvent event) async* {
    if (event is TitleFocused) {
      yield TitleWidget(focused: 1);
      return;
    }
    if (event is TitleUnfocused) {
      yield TitleWidget(focused: 0);
      return;
    }
  }
}
