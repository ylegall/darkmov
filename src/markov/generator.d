
module markov.generator;

import std.array;

import markov;

private
{
    alias immutable(ubyte[]) Token;
    alias Appender!(Token[]) TokenList;

    struct Node
    {
        TokenList tokenList;
        Node*[Token] nodeMap;
    }
}

class Generator
{
    private
    {
        File file;
        Node* root;
        size_t _lines;
        size_t _words;
        size_t _bytes;
    }

    this (File file) {
        this.file = file;
        init();
    }

    private void init() {
        // TODO:
    }

    private auto set(Token t1, Token t2, Token t3) {
        auto node1 = getOrCreateNode(root, t1);
        auto node2 = getOrCreateNode(node1, t2);
        node2.tokenList.put(t3);
    }

    private auto get(Token t1, Token t2) {
        // TODO:
    }

    private auto getOrCreateNode(Node* node, Token t) {
        Node* result = null;
        auto p = t in node.nodeMap;
        if (p) {
            result = *p;
        } else {
            result = new Node();
            node.nodeMap[t] = result;
        }
        return result;
    }

    auto next() {
        // TODO:
        //return token("");
    }

    auto bytes() {
        return _bytes;
    }

    auto lines() {
        return _lines;
    }

    auto words() {
        return _words;
    }

}

