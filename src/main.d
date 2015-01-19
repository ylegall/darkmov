
import std.stdio;
import std.getopt;

import markov;

struct Context
{
    long maxBytes  = -1;
    long maxWords  = -1;
    long maxLines  = -1;
}

auto greaterThan(ulong amount, long limit)
{
    return (limit >= 0 && amount > limit);
}


void main(string[] args)
{
    Context ctx;
    string inFilename;
    string outFilename;

    getopt(
        args,
        "file|f", &inFilename,
        "bytes|b", &ctx.maxBytes,
        "words|w", &ctx.maxWords,
        "lines|l", &ctx.maxLines,
        "output|o", &outFilename
    );

    auto inFile = (inFilename)? File(inFilename, "r") : stdin;
    auto outFile = (outFilename)? File(outFilename, "w") : stdout;

    auto generator = new Generator(inFile);

    while (true) {
        if (generator.bytes.greaterThan(ctx.maxBytes)) break;
        if (generator.words.greaterThan(ctx.maxWords)) break;
        if (generator.lines.greaterThan(ctx.maxLines)) break;
    }
}


