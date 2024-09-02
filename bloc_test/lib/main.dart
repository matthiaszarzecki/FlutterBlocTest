// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  //Bloc.observer = const AppBlocObserver(); // Init this to get printouts
  runApp(const App());
}

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
/*class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    if (bloc is Cubit) {
      print("A $change");
    }
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    print("B $transition");
  }
}*/

/// A [StatelessWidget] that:
/// * uses [bloc](https://pub.dev/packages/bloc) and
/// [flutter_bloc](https://pub.dev/packages/flutter_bloc)
/// to manage the state of a counter and the app theme.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

/// A [StatelessWidget] that:
/// * reacts to state changes in the [ThemeCubit]
/// and updates the theme of the [MaterialApp].
/// * renders the [CounterPage].
class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const CounterPage(),
    );
  }
}

/// A [StatelessWidget] that:
/// * provides a [PageBloc] to the [CounterView].
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PageBloc(),
      child: const CounterView(),
    );
  }
}

/// A [StatelessWidget] that:
/// * demonstrates how to consume and interact with a [PageBloc].
class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: BlocBuilder<PageBloc, Page>(
          builder: (context, page) {
            if (page == Page.image) {
              return Text(
                '$page',
                style: Theme.of(context).textTheme.displayLarge,
              );
            } else if (page == Page.qr) {
              return Text(
                '$page',
                style: Theme.of(context).textTheme.displaySmall,
              );
            } else  {
              return Text(
                '$page',
                style: Theme.of(context).textTheme.displaySmall,
              );
            }
          },
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.art_track_rounded),
            onPressed: () {
              context.read<PageBloc>().add(PageImagePressed());
            },
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.qr_code),
            onPressed: () {
              context.read<PageBloc>().add(PageBikePressed());
            },
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.bike_scooter),
            onPressed: () {
              context.read<PageBloc>().add(PageQRPressed());
            },
          ),
        ],
      ),
    );
  }
}

/// Event being processed by [PageBloc].
abstract class PageEvent {}

/// Notifies bloc to increment state.
class PageImagePressed extends PageEvent {}
class PageBikePressed extends PageEvent {}
class PageQRPressed extends PageEvent {}

/// A simple [Bloc] that manages an `int` as its state.
class PageBloc extends Bloc<PageEvent, Page> {
  PageBloc() : super(Page.image) {
    on<PageImagePressed>((event, emit) {
      emit(Page.image);
    });

    on<PageBikePressed>((event, emit) {
      emit(Page.bike);
    });

    on<PageQRPressed>((event, emit) {
      emit(Page.qr);
    });
  }
}

enum Page { image, qr, bike }

/// A simple [Cubit] that manages the [ThemeData] as its state.
class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData.light();
  static final _darkTheme = ThemeData.dark();

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    emit(
      state.brightness == Brightness.dark ? _lightTheme : _darkTheme,
    );
  }
}
