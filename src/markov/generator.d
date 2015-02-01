
module markov.generator;

import markov;

package
{
    struct Node
    {
        TokenList tokenList;
        NodeMap nodeMap;
    }
}

class Generator
{
    private {
        size_t _words;
        size_t _bytes;
        TrigramModel model;
        Token t1, t2;
        Random rand;
    }

    this (File file) {
        model = new TrigramModel(file);
        init();
    }

    private void init() {
        auto tokens = model.getInitialTokens(rand);
        t1 = tokens[0];
        t2 = tokens[1];
    }

    auto empty() {
        return false;
    }

    auto front() {
        return t1;
    }

    auto popFront() {
        auto temp = model.get(t1, t2, rand);
        t1 = t2;
        t2 = temp;
    }

    auto bytes() {
        return _bytes;
    }

    auto words() {
        return _words;
    }
}

class TrigramModel
{
    package
    {
        Node* root;
        Token t1, t2;
    }

    this (File file) {
        init(file);
    }

    void init(File file = stdin) {
        root = new Node();
        foreach (char[] line; file.byLine) {
            auto tokens = tokenize(line);
            foreach (token; tokens) {
                processToken(token);
            }
        }
        //printModel();
    }

    auto getInitialTokens(Random rand) {
        Token[2] tokens;
        tokens[0] = randomToken(root.nodeMap, rand);
        auto node = root.nodeMap[tokens[0]];
        tokens[1] = randomToken(node.nodeMap, rand);
        return tokens;
    }

    debug auto printModel() {
        writeln("dumping model contents:");
        foreach (key1; root.nodeMap.keys) {
            auto node = root.nodeMap[key1];
            foreach (key2; node.nodeMap.keys) {
                auto node2 = node.nodeMap[key2];
                foreach (str; node2.tokenList.data) {
                    writefln("%s -> %s -> %s", key1, key2, str);
                }
            }
        }
    }

    private void processToken(Token token) {
        if (t1 && t2) {
            set(t1, t2, token);
        }
        t1 = t2;
        t2 = token;
    }

    private auto set(Token t1, Token t2, Token t3) {
        auto node1 = getOrCreateNode(root, t1);
        auto node2 = getOrCreateNode(node1, t2);
        node2.tokenList.put(t3);
    }

    private auto getNode(Node* node, Token token) {
        return *(token in node.nodeMap);
    }

    auto get(Token t1, Token t2, Random rand) {
        auto node = getNode(root, t1);
        node = getNode(node, t2);
        enforce(node != null, "returned node was empty");
        return node.tokenList.data[uniform(0, node.tokenList.data.length)];
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
}

