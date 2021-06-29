# Hello Contibutors 🤗

Thanks for contributing to the project. We request you all to follow our [Code of conduct](./CODE_OF_CONDUCT.md)
If you are contributing for the first time then take a look at [this](https://www.dataschool.io/how-to-contribute-on-github/).

## Things to remember

- **Try to avoid adding new dependencies to save an hour**.
- Format your code by running `flutter format`
- Write short and concise commit message, follow [Semantic Commit Messages](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716).
- Any change to linting rules should be made only after discussion with the team.


## Project structure we follow

```
|--assets/                          # Assets for app(logos, fonts)
    |--images/
    |--fonts/
|--lib
    |--local_db/                    # Everything related local storage
    |--models/                      # Data models
        |--<name>_model/
            |--<name>_model.dart
            |--<name>_model.g.dart
    |--providers/                   # Every provider should be in different file
        |--<name>_provider.dart
    |--screens/                     # Contains all the UI elements of app
        |--<foo>_screen/            # Each screen should have a folder and follow foo_screen convention
            |--widgets/             # Smaller widgets which help in building the screen
            |--foo_screen.dart      # App screen
    |--utils/                       # Utilities for the application
        |--constants.dart           # String/Integer constants
        |--routes.dart              # Routing information
        |--themes.dart              # Themes for the application
    |--widgets/                     # Widgets which are shared between more than one screen
    |--main.dart                    # Entry point of any dart project
```

For tests same folder structure should be followed in `test/` folder.

## Application Layers

![Application layers](https://github.com/bizz84/starter_architecture_flutter_firebase/blob/master/media/application-layers.png?raw=true)

To ensure a good separation of concerns, this architecture defines three main application layers.

- **UI Layer**: where the widgets live
- **Logic & Presentation Layer**: this contains the application's business and presentation logic
- **Domain Layer**: this contains domain-specific services for interacting with 3rd party APIs

*These layers may be named differently in other literature.*

What matters here is that the data flows from the services into the widgets, and the call flow goes in the opposite direction.

Widgets **subscribe** themselves as listeners, while view models **publish** updates when something changes.

_[For more information](https://github.com/bizz84/starter_architecture_flutter_firebase#the-application-layers)_
