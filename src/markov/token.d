
module markov.token;

import markov;

alias string Token;
alias Appender!(Token[]) TokenList;
alias Node*[Token] NodeMap;

enum DEFAULT_PATTERN = `([\w\.\?!;]+)`;
enum DEFAULT_REGEX = ctRegex!(DEFAULT_PATTERN);

auto tokenize(T)(T line)
{
    return matchAll(line, DEFAULT_REGEX).map!(a => a.hit.idup);
}

auto tokenize(T)(T line, StaticRegex!char pattern)
{
    return matchAll(line, pattern).map!(a => a.hit.idup);
}

auto tokenize(T)(T line, Regex!char pattern)
{
    return matchAll(line, pattern).map!(a => a.hit.idup);
}

auto randomToken(NodeMap map)
{
    auto keys = map.keys;
    return keys[uniform(0, keys.length)];
}

auto randomToken(TokenList list)
{
    return list.data[uniform(0, list.data.length)];
}

unittest
{
    assert(equal(tokenize("one two. 'three' four? five six!", DEFAULT_REGEX),
                ["one", "two.", "three", "four?", "five", "six!"]
    ));
}
