import 'package:rxdart/rxdart.dart';

/// A business logic component abstracts all the logic from the view layer and feeds
/// to the view the data it needs. The view only cares about the UI and not about the data
/// it receives, as the bloc handles all data preparation.
/// The bloc connects the UI with the flow of data from a stream. It is commonly provided to a
/// widget subtree via an Inherited Widget.
class TestBloc {
  /// `Observable:` While an Array is 'a collection of values', an observable is 'a collection of values that arrives over time'.
  /// An observable emits streams of data which an Observer can listen and react to. You should be able to think of anything that implements IObservable<T>
  /// as a streaming sequence of T objects. So if a method returned an IObservable<Price> I could think of it as a stream of Prices. 
  ///
  /// `Observer:` In order for an observer to see the items being emitted by an Observable, or to receive error or completed notifications from the Observable,
  /// it must first subscribe to that Observable. The `subscribe` operator is the glue that connects an observer to an Observable. This is implemented
  /// by definig `onNext`, `onError` and `onCompleted` handlers as methods to an `Observer`, then the `Observable` can call these methods to notify the observer.
  ///
  /// A `Subject` is a stream controller that can A) emit data as an Observable and observers can subscribe to that subject, B) listen to data as an observer.
  /// The subject can receive data (through its `sink` property) and emit data (from its `stream` property).
  /// A subject maintains a list of its dependents, called observers, and notifies them automatically of any state changes, usually by calling one of their methods.
  /// A Subject is a `'hot' Observable`. A 'hot' Observable may begin emitting items as soon as it is created, and so any observer who later subscribes
  /// to that Observable may start observing the sequence somewhere in the middle.
  /// A `subject` notifies an `observer` by calling one of its methods.
  /// The main benefit of a subject is being able to broadcast new values to subscribers without having to rely on some source data.
  /// 
  /// I like to think of the IObserver<T> and the IObservable<T> as the 'reader' and 'writer' or, 'consumer' and 'publisher' interfaces.
  /// If you were to create your own implementation of IObservable<T> you may find that while you want to publicly expose the IObservable characteristics
  /// you still need to be able to publish items to the subscribers, throw errors and notify when the sequence is complete.
  /// Why that sounds just like the methods defined in IObserver<T>! While it may seem odd to have one type implementing both interfaces, it does make life easy.
  /// This is what subjects can do for you. `Subject<T>` is the most basic of the subjects.
  /// Effectively you can expose your Subject<T> behind a method that returns IObservable<T> but internally you can use the OnNext, OnError and OnCompleted methods
  /// to control the sequence. 
  ///
  /// `BehaviorSubject:` When an observer subscribes to a BehaviorSubject, it begins by emitting the item most recently emitted by the source Observable
  /// (or a seed/default value if none has yet been emitted) and then continues to emit any other items emitted later by the source Observable(s).
  /// It remembers the last publication and immediately emits it to the subscriber. This means that all subscribers will receive a value
  /// immediately (unless it is already completed). However, if the source Observable terminates with an error, the BehaviorSubject will not emit any items
  /// to subsequent observers, but will simply pass along the error notification from the source Observable.
  ///
  /// `PublishSubject:` Emits to an observer only those items that are emitted by the source Observable(s) subsequent to the time of the subscription, not the last item
  /// emitted before the subscription.
  ///
  /// `ReplaySubject:`  Emits to any observer all of the items that were previously emitted by the source Observable(s), regardless of when the observer subscribes.
  ///  Provides the feature of caching values and then replaying them for any late subscriptions.
  ///
  /// `AsyncSubject:` An AsyncSubject emits the last value (and only the last value) emitted by the source Observable, and only after that source Observable completes.
  final subject = new BehaviorSubject<int>();
}
