[8m ********************** HELP FILE - DO NOT DELETE. ********************** 
Author: T3RRY aka T3RR0R
[2;1H [28m
Syntax for defining macros with AutoMacro:
 @macroname { [ Dependencies: <@macroname> [@macroname] ["@macroname arg1 arg..."] ]
   [ @macroname usage: <arginfo> ]
   $set "preloadVar=Value"
   <$
     temporary script executed during macro definition
   $>
   <;
     multiline
     comments
   ;>
   macro function command/s
   ::  - a comment
   //  - a comment
   REM - a comment
 } @macroname [/args] [/argRequired] [/selfRef] [/help] [/?] [/expand] [/flush]
 
 note: 'macroname {' and '} macroname' are opening and closing tags.
        Macro Initialization args are available in the Variable setup.args if provided.

        All unremarked lines after the Opening tag (after the last instance of "@macroname usage:" until the matching
        closing tag will be defined to the macro.
        If usage info is provided on the line following the opening tag, it will be defined to macroname_usage
         $Set : defines the subsequent variable / value pair and excludes the line from the macro.
                use this when a variable only needs to be defined once for use during macro expansions.
         $for : execute the for loop during macro definition. Currently supports SINGLE LINE STATEMENTS ONLY.
                use this to generate macro content dynamically without defining the command line into the macro.
         <$ $>: Scripting block: use this for generative code / dynamic macros requiring more complex scripting
                than basic Set or For commands. Note: CHCP cannot be used during scripting blocks as it breaks the file
                reading mechanism used to parse macro's.
        /args : wraps the macro with a For loop to capture args in @macroname.args
 /argRequired : Reject execution if no Args provided. requires /args usage; over-rules /help if both used.
     /selfRef : Substitutes @. in macros to macroname. - Do not use with variable names that contain "()<>" etc.
        /help : displays usage info if @macroname.args not defined. requires /args usage
 .||       /? : creates a help file to be displayed by using the HELP macro, IE %Help% macroname
       /flush : undefine all macro specific temp variables prefixed with @. or @macroname. after executing macro
 Dependencies : Defines supplied macro Arguments to enable embedding in the Host macro definition using
                Delayed Expansion. Dependencies are assumed to be in the same file as the host
       
 *** comment lines: " :: " // ", or " REM ", or <; multiline comments ;> will be excluded from the macro definition.
                     leading and trailing whitespace is expected for single line comments within macros.
 multiline remarks:  initiate a multiline comment using: <;
                    terminate a multiline comment using: ;>
 
 ! escaping:
            Single escape any expansion of delayed variable you wish to expand at runtime, IE: ^!@.args^!
            Embedded macros should not be escaped. 
 To pass arguments containing poison characters to a macro:
            double quote the argument string
            triple escape any ! characters
            example:
           %@macroname% "some ^^^ <> & poison ^^^!"
 
 AutoMacro's can self reference [via string substitution]. Use the /selfRef switch to automatically replace all
 instances of @. within a macro's definition with macroname.

 *** To enable macro debugging files, use the /debug switch when calling AutoMacro

Troubleshooting:
 In the event your macro is not defined, and no debug data is present in the scripts debug file when /debug is used:
 Your script has a syntax or spelling error with one or more of the following tags:
 opening tag: @macroname {
 closing tag: } @macroname
 usage   tag: @macroname usage: 