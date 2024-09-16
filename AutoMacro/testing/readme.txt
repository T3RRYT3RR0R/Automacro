[8m ********************** HELP FILE - DO NOT DELETE. ********************** 
Author: T3RRY aka T3RR0R
[2;1H [28m
Syntax for defining macros with AutoMacro:
 [33m@macroname { [90m[[33mDependencies: [90m<[33m@macroname[90m> [[33m@macroname[90m] [[33m"@macroname arg1 arg..."[90m]]
   [90m[ [33m@macroname usage: info[90m ][0m
[33m   $set "preloadVar=Value"[0m
[33m   <$[0m
[90m     rem temporary batch script executed during macro definition. script is executed in Echo off state, in the environment of the calling script.
[33m   $>[0m
[33m   <;[0m
     multiline
     comments
[33m   ;>[0m
[33m   macro command/s[0m
[33m   ::  [0m- a comment
[33m   //  [0m- a comment
[33m   REM [0m- a comment
[33m } @macroname [90m[[33m/args[90m] [[33m/argRequired[90m] [[33m/selfRef[90m] [33m[/help[90m] [[33m/?[90m] [[33m/expand[90m] [[33m/flush[90m][0m
 
 note: '[33mmacroname {[0m' and '[33m} macroname[0m' are opening and closing tags.
        Macro Initialization args are available in the Variable setup.args if provided.
        Each such tag MUST be positioned at the beginning of the line.
        All unremarked lines after the Opening tag (after the last instance of "[33m@macroname usage:[0m" until the mathcing
        closing tag will be defined to the macro.
        If usage info is provided using the on the line following the opening tag, it will be defined to [33mmacroname_usage[0m.
        Macro usage info is defined by prefixing lines using:
        @macroname usage: 
        Macro usage info supports the following styling tags to apply VT color codes and graphics rendition settings:
[0m        [31m<red> [32m<green> [33m<yellow> [34m<darkblue> [35m<purple> [36m<lightblue> [37m<white> [0m<default> [5m<flash>[0m

[33m         $Set[0m : defines the subsequent variable / value pair and excludes the line from the macro.
                use this when a variable only needs to be defined once for use during macro expansions.
[33m         $for[0m : execute the for loop during macro definition. Currently supports SINGLE LINE STATEMENTS ONLY.
                use this to generate macro content dynamically without defining the command line into the macro.
[33m         <$ $>[0m: Scripting block: use this for generative code / dynamic macros requiring more complex scripting
                than basic Set or For commands. Note: CHCP cannot be used during scripting blocks as it breaks the file
                reading mechanism used to parse macro's.
[33m        /args[0m : wraps the macro with a For loop to capture args in @macroname.args
[33m /argRequired[0m : Reject execution if no Args provided. requires /args usage; over-rules /help if both used.
[33m     /selfRef[0m : Substitutes @. in macros to macroname. - Do not use with variable names that contain "()<>" etc.
[33m        /help[0m : displays usage info if @macroname.args not defined. requires /args usage
[33m           /?[0m : creates a help file to be displayed by using the HELP macro, IE %Help% macroname
[33m       /flush[0m : undefine all macro specific temp variables prefixed with @. or @macroname. after executing macro
[33m Dependencies[0m : Defines supplied macro Arguments to enable embedding in the Host macro definiton using
                Delayed Expansion. Dependencies are assumed to be in the same file as the host
       
 *** comment lines: " [33m::[0m " [33m//[0m ", or " [33mREM[0m ", or [33m<;[0m multiline comments [33m;>[0m will be excluded from the macro definiton.
     - leading and trailing whitespace is expected for single line comments within macros.
     Multiline remarks: 
[33m<;[0m - initiate a multiline comment. 
[33m;>[0m - terminate a multiline comment.
 
 ! escaping:
            Single escape any expansion of delayed vairable you wish to expand at runtime, IE: [33m^!@.args^![0m
            Embedded macros should not be escaped. 
 To pass arguments containing poison characters to a macro:
            double quote the argument string
            triple escape any ! characters
            example:
           [36m%[33m@macroname[36m%[33m "some ^^^ <> & posion ^^^!"[0m
 
 AutoMacro's can self reference [via string substitution]. Use the [33m/selfRef[0m switch to automatically replace all
 instances of @. within a macro's definition with macroName.

 *** To enable debugging of macro files, use the [33m/debug[0m switch when calling AutoMacro:
 [33mCall AutoMacro.bat @macroname /debug[0m

Troubleshooting:
 In the event your macro is not defined, and no debug data is present in the scripts debug file when /debug is used:
 Your script has a syntax or spelling error with one or more of the following tags:
 opening tag:[33m @macroname {[0m
 closing tag:[33m } @macroname[0m
 usage   tag:[33m @macroname usage:[0m