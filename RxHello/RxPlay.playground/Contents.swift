import UIKit
import RxSwift
import RxCocoa
import RxBiBinding

let dBag = DisposeBag()
/*
// MARK: Observables and Observers
// Observer is the basic consumer of input event sequences which creates a subscription event
// Observable is the basic output sequence

let myObservable = Observable<String>.create { observer in
    observer.onNext("First Value")
//    observer.onCompleted() // this observer will not observer anymore because of complete even same will happen in onError event.
    observer.onError(RxError.noElements)
    observer.onNext("Second value")
    return Disposables.create()
}
myObservable.subscribe(onNext: { (value) in
    print(value)
    }).disposed(by: dBag)

myObservable.debug().subscribe(onNext: { (val) in // debug can be used to check events

}, onError: { (error) in

}, onCompleted: {

}) {

}.disposed(by: dBag)

let justObservable = Observable.just([1,2,3])
let ofObservable = Observable.of("A", "B", "C")
let fromObservable = Observable.from([1,2,3])

// Observales are read only. You can't call onNext or accept.
//justObservable.onNext(2) // error


let single = Single<Int>.create { observer in
    observer(.success(2))
    //    observer(.error(RxError.noElements))
    return Disposables.create()
}
single.subscribe(onSuccess: { (element) in
//    print(element)
}) { (error) in
    print(error.localizedDescription)
}

// MARK: Subjects : Publish and Behaviour
// Main difference is Publish subject doesn't take initial value whereas Behaviour subjects take an initial value.

let pubSub = PublishSubject<String>()
// for passing value we can use onNext()

pubSub.onNext("A") // it will not be emitted because no one is subscribing to it.

pubSub.subscribe(onNext: { (value) in
//    print(value)
}).disposed(by: dBag)

pubSub.onNext("B") // This will be emitted
*/

let behSub = BehaviorSubject<Int>(value: 1) // Initial val
behSub.onNext(2) // Behaviour Subject emitts the last 1 value.
behSub.subscribe(onNext: { (value) in
    print(value)
    }).disposed(by: dBag)

behSub.onNext(3)
behSub.onNext(4)

// Bonus Replay subject can hold some values, it emitts last n values (n is buffer size).

let replaySub = ReplaySubject<Int>.create(bufferSize: 2)
//let replayAll = ReplaySubject<Int>.createUnbounded() // careful with this as it will store everything.
replaySub.onNext(1)
replaySub.onNext(2)
replaySub.onNext(3)
replaySub.subscribe(onNext: { (value) in
    print(value)
    }).disposed(by: dBag)

replaySub.onNext(4)

//let asyncSub = AsyncSubject<Int>() // emitts only the last item when onComplete is called.


// MARK: Publish and Behaviour Relays

// Just like Subjects the differece between Publish and Behaviour Relay is the initial value.

let pubRelay = PublishRelay<String>()
pubRelay.accept("A")

pubRelay.subscribe(onNext: { (value) in
//    print(value)
    }).disposed(by: dBag)

pubRelay.accept("B")

pubRelay.subscribe(onNext: { (val) in

}, onError: { (err) in
    // this will never be called
}, onCompleted: {
    // this will never be called
}) {
//    print("disposed")
}.disposed(by: dBag)

let behRelay = BehaviorRelay<String>(value: "AA")
behRelay.accept("BB")

behRelay.subscribe(onNext: { (value) in
//    print(value)
    }).disposed(by: dBag)

//MARK: Driver and Signal
// Both are gureented to be on main thead and will never error out.
let driver = Driver<String>.from(["AAA", "BBB"])
driver.drive(onNext: { (value) in
//    print(value)
}, onCompleted: {
//    print("completed")
}) {
//    print("disposed")
}.disposed(by: dBag)

let signal = Signal<String>.from(["1", "b"])
//signal.emit(onNext: { (val) in
//    print(val)
//}, onCompleted: {
//    print("comp")
//}) {
//    print("dispose")
//}.disposed(by: dBag)
//

signal.do(onNext: { (val) in
//    print(val+val)
}).emit(onNext: { (original) in
//    print(original)
    }).disposed(by: dBag)


// MARK: Binding

let sub = PublishSubject<String>()
let sub2 = PublishSubject<String>()

sub.bind(to: sub2)

sub2.subscribe(onNext: { (val) in
    print(val)
    }).disposed(by: dBag)

sub.subscribe(onNext: { (val) in
    print(val)
    }).disposed(by: dBag)

sub2.onNext("Ankur")



// Two-way binding

let tSub = BehaviorRelay<Int>(value: 0)
let tSub2 = BehaviorRelay<Int>(value: 0)



(tSub <-> tSub2).disposed(by: dBag)



tSub.subscribe(onNext: { (value) in
    print(value)
    }).disposed(by: dBag)


tSub2.subscribe(onNext: { (value) in
    print(value)
}).disposed(by: dBag)

tSub2.accept(6)
tSub.accept(5)



//MARK: ObserveOn vs SubscribeOn

// observeOn changes the thread of everything downstream basically if you have subscribedOn a background thread you
// subscribeOn changes the thread up and down stream. It can't ride observeOn thread.


Observable<Int>.create { observer in
    observer.onNext(1)  // Subscription code it will not execute until you call subscribe(onNext:)
    print(Thread.isMainThread)
    sleep(1)
    observer.onNext(2)
    return Disposables.create()
    }.map({$0})
.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    .observeOn(MainScheduler.instance)
.subscribe(onNext: { el in
    print(Thread.isMainThread) // Observing code.
})





// MARK: ControlProperties and ControlEvents
//ControlEvent is an Observable trait
//UIBindingObserver is an Observer trait
//ControlProperty has both traits’s attributes and is an Observable sequence as well as an Observer
//https://christiantietze.de/posts/2017/06/rxswift-ui-components/#:~:text=rx.,user%2Dgenerated%20changes%20as%20well.

//MARK: ObserveOn vs SubscribeOn


/*
// BehaviourRelay
enum MyError: Error {
    case internalIssue
}

let relay = BehaviorRelay(value: "Initial Val")
relay.accept("new string")
relay.accept("new string111")
relay.subscribe(onNext: { val in
    print(val)
})
relay.accept("New value")

var array = [1,2,3,4,5]
array.removeAll(keepingCapacity: true)
print(array.capacity)
print(array)

// ignoreElements will ignore all element callback but completed.

let ign = PublishSubject<String>()

ign.ignoreElements().subscribe( { element in
    print("Elements ignored")
})


ign.onNext("El1")
ign.onNext("El2")
ign.onNext("El3")
ign.onCompleted()


let elementAt = PublishSubject<String>()
elementAt.elementAt(2).subscribe( onNext: { val in
    print(val)
    print("You are called")
})

elementAt.onNext("A1")
elementAt.onNext("A2")
elementAt.onNext("A3")


let filSub = PublishSubject<Int>()

filSub.filter({
    $0 > 5
}).subscribe( onNext: { val in
    print(val)
})

filSub.onNext(2)
filSub.onNext(4)
filSub.onNext(6)
filSub.onNext(9)


let skipp = Observable.from([1,2,3,4,5,6])
skipp.skip(2).subscribe( onNext: { val in
    print(val)
    }).disposed(by: dBag)


let skipwhileee = Observable.from([2, 2, 3, 4, 5, 6, 7])

skipwhileee.skipWhile({ $0%2 == 0}).subscribe(onNext: {
    print($0)
    }).disposed(by: dBag)

let skipUntilll = PublishSubject<String>()
let trigger = PublishSubject<String>()

skipUntilll.skipUntil(trigger).subscribe( onNext: {
    print($0)
})

skipUntilll.onNext("A")
skipUntilll.onNext("B")
trigger.onNext("z")
skipUntilll.onNext("C")
skipUntilll.onNext("D")

*/
/*
let takke = Observable.from([1,2,3,4,5])
takke.take(2).subscribe(onNext: {
    print($0)
})

let takkeWhile = Observable.from([2,4,2,3,4,5])
takkeWhile.takeWhile({$0%2 == 0 }).subscribe(onNext: {
    print($0)
})

let takkUntil = PublishSubject<String>()
let takTrigger = PublishSubject<String>()

takkUntil.takeUntil(takTrigger).subscribe(onNext:{
    print($0)
    }).disposed(by: dBag)

takkUntil.onNext("A")
takkUntil.onNext("B")
takTrigger.onNext("z")
takkUntil.onNext("C")


// Toarray

let t2oArr = Observable.of(10, 20, 30, 40)

t2oArr.toArray().asObservable().subscribe(onNext: {
    print($0)
    }).disposed(by: dBag)

// Map

let mapp = Observable.of(1,2,3,4,5)

mapp.map({
    return $0 * $0
}).subscribe(onNext:{
    print($0)
    }).disposed(by: dBag)

// Flatmap and FlatmapLatest

//startswith

// Concat

let con = Observable.of(1,2,3)
let cat = Observable.of(4,5,6)

con.concat(cat).asObservable().subscribe(onNext:{
    print($0)
})

//merge

let me = PublishSubject<String>()
let rge = PublishSubject<String>()

let merge = Observable.of(me, rge)

merge.merge().subscribe(onNext: {
    print($0)
})


me.onNext("A")

me.onNext("U")
rge.onNext("R")
rge.onNext("N")
rge.onNext("K")

*/
