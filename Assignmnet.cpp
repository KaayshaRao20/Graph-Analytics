#include <bits/stdc++.h>
using namespace std;

long long roadsAndLibraries(int n, long long c_lib, long long c_road, vector<vector<int>>& cities) {
    if (c_lib <= c_road) {
        return (long long)n * c_lib;
    }

    vector<vector<int>> graph(n + 1);
    for (auto& edge : cities) {
        graph[edge[0]].push_back(edge[1]);
        graph[edge[1]].push_back(edge[0]);
    }

    vector<bool> visited(n + 1, false);
    long long total_cost = 0;

    for (int city = 1; city <= n; city++) {
        if (!visited[city]) {
            stack<int> st;
            st.push(city);
            visited[city] = true;
            int component_size = 0;

            while (!st.empty()) {
                int u = st.top();
                st.pop();
                component_size++;
                for (int v : graph[u]) {
                    if (!visited[v]) {
                        visited[v] = true;
                        st.push(v);
                    }
                }
            }

            total_cost += c_lib + (long long)(component_size - 1) * c_road;
        }
    }

    return total_cost;
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int q;
    cin >> q;
    while (q--) {
        int n, m;
        long long c_lib, c_road;
        cin >> n >> m >> c_lib >> c_road;

        vector<vector<int>> cities(m, vector<int>(2));
        for (int i = 0; i < m; i++) {
            cin >> cities[i][0] >> cities[i][1];
        }

        cout << roadsAndLibraries(n, c_lib, c_road, cities) << "\n";
    }
    return 0;
}
