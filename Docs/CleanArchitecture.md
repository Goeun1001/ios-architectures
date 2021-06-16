# Clean Architecture

![img](https://blog.kakaocdn.net/dn/b1WEWl/btqFK3PZ9oR/Zf0MW7IZfKT2d8bFZs3yX1/img.jpg)

Clean architecture structures your code in concentric layers to achieve *The Dependency Rule* Which is*:*

> Nothing in an inner circle can know anything at all about something in an outer circle.

It divides the project into 3 layers:

### Presentation Layer

- Contains UI (UIView, UIViewControllers) and also Presenter/ ViewModel.
- Presenter/ ViewModel are responsible for executing one or many use cases. It considered as mediator between use case and UI.
- It depends on **Domain Layer**.
- Presenter/ ViewModel shouldn’t import UIKIt to be more testable.

### Domain Layer

It is the independent layer which includes the business logic of the app with the following characteristics:

- Contains Entities, Use cases and repository protocol.
- Each use case executes a single business unit.
- It is totally independent and can be reused by other projects.
- Fetches data from Repository through repository protocol.
- Domain layer doesn’t know any thing about outer layers(Presentation, Data)

### Data Layer

- It contains repository, Data stores.
- It uses repository design pattern. A design pattern that provides abstraction of data.
- Its responsible for getting data from data source whether it is local (DB) or remote (API).
- Business logic doesn’t know where the data come from. just tell the repository that it needs data and the repo decides where to fetch them.
- It depends on **Domain Layer.**

There is also one principal that clean architecture provide which is **Screaming Architecture**



## Dependency Direction

![Alt text](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/raw/master/README_FILES/CleanArchitectureDependencies.png?raw=true)

**Note:** **Domain Layer** should not include anything from other layers(e.g Presentation or Data Layer)



![Clean Architecture](https://blog.kakaocdn.net/dn/bHEH6y/btqFKMhY1wf/Ted9svEN3OwQzwt1gij7ek/img.jpg)

The example app has a structure that is almost similar to the picture if you change the Presenter in the picture above to a ViewModel. And the example app has a separate Application layer, which includes Domain, Data, and Presentation.



## Example - [Clean MVVM](https://github.com/Goeun1001/ios-architectures/tree/master/Clean-MVVM)

![Clean-MVVM](/Users/jge/Documents/dev/JGE-ios-architecture/Docs/images/Clean-MVVM.png)

- **Domain Layer** = Entity + Use Case + Repositories Interface + Networking Infra
- **Data Repositories Layer** = Repository Implementation + CoreData
- **Presentation Layer (MVVM)** = View + ViewController + ViewModel



### Reperence

- [MVP, MVVM and Clean architecture in iOS](https://medium.com/@salma.salah.ashour/mvp-mvvm-and-clean-architecture-in-ios-49643b456a5)
- [kudoleh](https://github.com/kudoleh) / [iOS-Clean-Architecture-MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)

