#include <bits/stdc++.h>
using namespace std;

const int MAXN = 200005;

vector<int> g[MAXN];

int t, b, f, c;
int inTime[MAXN];
int depthArr[MAXN];
int timerVal = 0;

set<pair<int, int> > finished;
vector<int> st;

void dfs(int u)
{
    inTime[u] = timerVal++;
    st.push_back(u);

    // First process all tree edges.
    for (int v : g[u])
    {
        depthArr[v] = depthArr[u] + 1;
        dfs(v);
    }

    st.pop_back();

    // Add back edges.
    for (int v : st)
    {
        if (b == 0)
            break;

        g[u].push_back(v);
        b--;
    }

    // Add cross edges.
    for (set<pair<int, int> >::iterator it = finished.begin();
         it != finished.end() && c > 0;
         ++it)
    {
        if (it->first >= inTime[u])
            break;

        int v = it->second;

        g[u].push_back(v);
        c--;
    }

    // Add forward edges.
    for (set<pair<int, int> >::reverse_iterator it = finished.rbegin();
         it != finished.rend() && f > 0;
         ++it)
    {
        if (it->first <= inTime[u])
            break;

        int v = it->second;

        // This edge would already be a tree edge.
        if (depthArr[v] == depthArr[u] + 1)
            continue;

        g[u].push_back(v);
        f--;
    }

    finished.insert(make_pair(inTime[u], u));
}

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(NULL);

    cin >> t >> b >> f >> c;

    int n = t + 1;

    /*
        Minimum possible sum of depths required for:
        - all forward edges
        - all back edges
    */
    long long minSumH = max(
        (long long)t + f,
        (long long)b
    );

    /*
        Maximum possible sum of depths when we reserve
        enough pairs for cross edges.
    */
    long long maxSumH =
        1LL * n * (n - 1) / 2 - c;

    // Impossible case.
    if (maxSumH < minSumH)
    {
        cout << -1 << '\n';
        return 0;
    }

    /*
        Construct a DFS tree.

        sumH = sum of depths of all vertices.
    */
    long long sumH = t;

    for (int i = 1; i < n; i++)
    {
        if (sumH + i - 1 <= minSumH)
        {
            // Make i a child of i-1.
            g[i - 1].push_back(i);

            sumH += i - 1;
        }
        else
        {
            /*
                Attach i to a suitable earlier vertex
                so that the required depth sum is obtained.
            */
            int parent = (int)(minSumH - sumH);

            if (parent < 0 || parent >= i)
            {
                cout << -1 << '\n';
                return 0;
            }

            g[parent].push_back(i);

            sumH += minSumH - sumH;
        }
    }

    if (sumH < minSumH)
    {
        cout << -1 << '\n';
        return 0;
    }

    /*
        Run DFS.

        During DFS we add exactly:
        b back edges
        f forward edges
        c cross edges
    */
    dfs(0);

    /*
        If anything remains, no valid construction
        was possible.
    */
    if (b != 0 || f != 0 || c != 0)
    {
        cout << -1 << '\n';
        return 0;
    }

    /*
        HackerRank requires vertices numbered from 1.
        Internally we used 0-based numbering.
    */
    cout << n << '\n';

    for (int i = 0; i < n; i++)
    {
        cout << g[i].size();

        for (int j = 0; j < (int)g[i].size(); j++)
        {
            cout << " " << g[i][j] + 1;
        }

        cout << '\n';
    }

    return 0;
}
