# turing_deal

Turing deal app

## Getting Started

This project can be executed like any flutter application just by importing in android studio, flutter pub get and running in a device

Ideas about the arquitecture of the app:

> lib -> All the flutter code
    > data
        > api -> external API calls definition
        > core -> algorithms and computation stuff
            > strategy -> Stuff related with the evaluation of a trading strategy
        > state -> state machine
        > screen -> Widgets to define entire screens of the app
            . bigPictureScreen ->  Screen to have a snapshot of how multiple assets are performing in the market  
