import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(state) : super(state);

  set value(T value) => emit(value);
  T get value => this.state;
}