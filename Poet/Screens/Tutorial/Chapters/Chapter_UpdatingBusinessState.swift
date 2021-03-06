//
//  Chapter_chapter_UpdatingBusinessState.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_UpdatingBusinessState: Chapter {
        return Chapter(
            "Updating Business State",
            files: [
                "HelloWorld-Screen",
                "HelloWorld-Evaluator",
                "HelloWorld-Translator"
            ],
            pages:
            Page([
                .demo(.showHelloWorld),
                .text("A clean separation of business state, display state, and view logic don't mean much to us unless we can perform updates easily."),
                .text("If you tap the button that says “Hello World,” you'll see a screen that includes some basic user interaction and some very minimal updates to state."),
                
                // MARK: The Objective
                
                .title("The Objective"),
                .text("The Hello World screen shows a speech bubble whenever we tap a button that says “Say Hello,” and it hides the bubble whenever we tap another button that says “Say Nothing.”"),
                .text("It also keeps track of how many times we have tapped “Say Hello” and displays that count as text on screen."),
                
                // MARK: How It's Made
                
                .title("How It's Made"),
                .text("In its structure, Hello World isn't too different from the Template example we've already seen. That previous screen's evaluator only included one meaningful step, named text. Similarly, Hello World's evaluator includes one meaningful step it calls sayStuff."),
                .code(
                    """
                    enum State: EvaluatorState {
                        case initial
                        case sayStuff(SayStuffState)
                    }
                    
                    struct SayStuffState {
                        var helloCount: Int
                        var bubbleText: String?
                        var buttonAction: Action
                    }
                    """
                ),
                .file("HelloWorld-Evaluator"),
                .text("But this evaluator also knows about two Actions, named sayHello and sayNothing."),
                .text("To do its job, Hello World's evaluator needs to configure its sayStuff step, and it also needs to respond to — or evaluate — the actions sayHello and sayNothing whenever the view layer asks."),
                .text("It turns out all of this work — both setting the initial step and performing updates — are a matter of setting state."),
                .title("Initial State"),
                .text("Like all evaluators, Hello World's begins in an empty state represented by the initial step."),
                .text("After the view appears, the evaluator calls its showSayStuffStep method, which configures the sayStuff step for the first time:"),
                .code(
                    """
                    let configuration = SayStuffState(
                        helloCount: 0,
                        bubbleText: nil,
                        buttonAction: Action.sayHello
                    )
                    current.step = .sayStuff(configuration)
                    """
                ),
                .text("We can see in the configuration that we keep track of how many times we've said “hello,” using an integer value. And we answer two other questions:"),
                .bullet("Does our bubble say anything?"),
                .bullet("What action will our button have?"),
                .text("The bubble text can be nil, whereas an action will always be present for this particular step."),
                .text("It's fundamental to Poet that the sayStuff step contains all information needed to perform any sort of logic, both behind the scenes and on screen."),
                .text("We don't store helloCount as a property of our evaluator, for instance. If we did that, more complex screens with multiple steps would become difficult to manage, as we would have a long list of properties which don't properly belong alongside each other."),
                .text("Why do we store an action in the configuration?"),
                .text("We wouldn't need to do that if the action didn't change over time. It would be fine to name a specific action in HelloWorld-Screen, for instance, where the screen knows its evaluator concretely."),
                .text("In our case, though, we choose a different action at different times: sometimes sayHello, and sometimes sayNothing. Our configuration lets us make that choice explicitly.")
            ])
            
            // ////////////////////////////////////
            
            /*
             Page([
             .text("In the evaluator, our buttonTapped(:) method is where we first hear that a button was tapped."),
             .smallCode(
             """
             func evaluate(_ action: EvaluatorAction?) {
             // …
             }
             """
             )
             ]),
             
             Page([
             .text("Within that method, we make sure the general EvaluatorAction type sent to us is really the ButtonAction type we expect:"),
             .smallCode(
             """
             guard let action = action as? ButtonAction else { return }
             """
             )
             ]),
             
             Page([
             .text("Then we switch on the action and call a method to handle it:"),
             .code(
             """
             switch action {
             case .pageForward:
             pageForward()
             """
             )
             ], supplement: Supplement(shortTitle: "buttonTapped()", fullTitle: "", body:[
             .code(
             """
             extension Tutorial.Evaluator: ActionEvaluating {
             func evaluate(_ action: EvaluatorAction?) {
             guard let action = action as? ButtonAction else { return }
             switch action {
             
             case .pageForward:
             pageForward()
             
             case .pageBackward:
             pageBackward()
             
             case .advanceWorldImage:
             advanceWorldImage()
             
             case .helloWorld:
             showWorldStep()
             
             case .returnToTutorial(let chapterIndex, let pageIndex, let pageData):
             showInterludeStep()
             afterWait(200) {
             self.showPageStep(
             forChapterIndex: chapterIndex,
             pageIndex: pageIndex,
             pageData: pageData)
             }
             
             case .showChapter(let chapterIndex, let pageData):
             self.showPageStep(
             forChapterIndex: chapterIndex,
             pageIndex: 0,
             pageData: pageData)
             }
             }
             }
             """
             )
             ])),
             
             Page([
             .text("Now the evaluator begins the work of reflecting on its current state and then updating it. It starts by looking at our current “step.”"),
             ]),
             
             Page([
             .text("The evaluator always has one and only one current step. A step is a simple enum case that represents a coherent unit of business state."),
             ]),
             
             Page([
             .text("Our evaluator has a few different steps it could be in, including a .page step:"),
             .code(
             """
             case page(PageState)
             """)
             ], supplement: Supplement(shortTitle: "Step", fullTitle: "", body: [
             .code(
             """
             enum Step: EvaluatorStep {
             case initial
             case interlude
             case mainTitle(MainTitleState)
             case chapterTitle(ChapterTitleState)
             case page(PageState)
             }
             """)
             ])),
             
             Page([
             .text("We should currently be in the page step. We'll check just to make sure:"),
             .code(
             """
             func pageForward() {
             guard case let .page(configuration)
             = current.step else { return }
             """)
             ]),
             
             Page([
             .text("Now we know our current step's state, stored as a PageState. That configuration has lots of data stored on it:"),
             .code(
             """
             struct PageState {
             var chapterIndex: Int
             var pageIndex: Int
             var pageData: [Chapter]
             // etc.
             """)
             ], supplement: Supplement(shortTitle: "PageState", fullTitle: "", body: [
             .code(
             """
             struct PageState {
             var chapterIndex: Int
             var pageIndex: Int
             var pageData: [Chapter]
             
             // Computed
             var title: String { return pageData[chapterIndex].title }
             var body: [Page.Body] { return pageData[chapterIndex].pages[pageIndex].body }
             var supplement: [Page.Body]? { return pageData[chapterIndex].pages[pageIndex].supplement }
             var chapterNumber: Int { return chapterIndex + 1 }
             var pageNumber: Int { return pageIndex + 1 }
             var pageCountWithinChapter: Int { return pageData[chapterIndex].pages.count }
             var chapterCount: Int { return pageData.count }
             var buttonAction: ButtonAction? { return pageData[chapterIndex].pages[pageIndex].action }
             var selectableChapterTitles: [NumberedNamedEvaluatorAction] { return selectableChapterTitles(for: pageData)}
             
             // Helper methods
             // ...
             }
             """)
             ])),
             
             Page([
             .text("We'll use the configuration's data to reason about our current business state. We've been asked to page forward, but first we need to figure out if we're in the middle of a chapter or at the end of one.")
             ]),
             
             Page([
             .text("We know there are two values stored in our page configuration which will let us figure that out:"),
             .code(".pageIndex"),
             .text("and"),
             .code(".pageCountWithinChapter")
             ]),
             
             Page([
             .text("Notice that all the data we need is on the configuration itself. We haven't looked anywhere else. In most implementations of the Poet pattern, the configuration is always the entire source of truth for the evaluator's state.")
             ]),
             
             Page([
             .text("Why be so exacting? By making the step the source of truth, we can avoid ambiguous or mismatched state. There is no global state, on the evaluator or beyond, to mismanage. There is only what is defined on the current step.")
             ]),
             
             Page([
             .text("If we determine that we are in the middle of a chapter, we'll figure out the next page index and ask to show it:"),
             .code(
             """
             showPageStep(
             forChapterIndex: nextChapter,
             pageIndex: nextPage,
             pageData: configuration.pageData)
             """)
             ]),
             
             
             Page([
             .text("We'll do a little extra if we're at the end of a chapter:"),
             .code(
             """
             showInterludeStep()
             afterWait(500) {
             self.showChapterTitleStep( ... )
             afterWait(1000) {
             self.showPageStep( ... )
             """)
             ], supplement: Supplement(shortTitle: "pageForward()", fullTitle: "", body: [
             .code(
             """
             func pageForward() {
             // Must be in Page step
             guard case let .page(configuration) = current.step else { return }
             
             var isNewChapter = false
             
             let (nextChapter, nextPage): (Int, Int) = {
             if configuration.pageIndex < configuration.pageCountWithinChapter - 1 {
             return (configuration.chapterIndex, configuration.pageIndex + 1)
             } else {
             isNewChapter = true
             if configuration.chapterIndex < configuration.chapterCount - 1 {
             return (configuration.chapterIndex + 1, 0)
             } else {
             return (0, 0)
             }
             }
             }()
             
             if isNewChapter {
             showInterludeStep()
             afterWait(500) {
             self.showChapterTitleStep(
             forChapterIndex: nextChapter,
             pageData: configuration.pageData)
             afterWait(1000) {
             self.showPageStep(
             forChapterIndex: nextChapter,
             pageIndex: nextPage,
             pageData: configuration.pageData)
             }
             }
             } else {
             showPageStep(
             forChapterIndex: nextChapter,
             pageIndex: nextPage,
             pageData: configuration.pageData)
             }
             }
             """)
             ])),
             
             Page([
             .text("What does it mean to “show” a step? We just make a new configuration and save it:"),
             .code(
             """
             let configuration = PageState(
             chapterIndex: chapterIndex,
             pageIndex: pageIndex,
             pageData: pageData
             )
             
             current.step = .page(configuration)
             """
             )
             ], supplement: Supplement(shortTitle: "showPageStep()", fullTitle: "", body: [
             .code(
             """
             func showPageStep(forChapterIndex chapterIndex: Int, pageIndex: Int, pageData: [Chapter]) {
             let configuration = PageState(
             chapterIndex: chapterIndex,
             pageIndex: pageIndex,
             pageData: pageData
             )
             
             current.step = .page(configuration)
             }
             """
             )
             ])),
             
             Page([
             .text("When we save the step, our Translator will hear about it. That's because the step is a “Passable” type that publishes its changes:"),
             .code("var current = PassableStep(Step.initial)")
             ]),
             
             Page([.text("PassableStep is just a helpful wrapper:"),
             .smallCode(
             """
             class PassableStep<S: EvaluatorStep> {
             var subject = PassthroughSubject<S, Never>()
             
             var step: S {
             willSet { subject.send(newValue) }
             }
             
             init(_ step: S) { self.step = step }
             }
             """
             )
             ]),
             
             Page([.text("The translator listens to the passable step by making a sink for its published values:"),
             .code(
             """
             init(_ state:
             PassableStep<Evaluator.Step>) {
             behavior = state.subject.sink
             { value in
             self.translate(step: value)
             }
             }
             """
             )
             ]),
                
             Page([.text("So, with the translator already set up properly, the evaluator completes its work simply by saving a new step.")])
             */
        )
    }
}
