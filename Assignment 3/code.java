import java.io.*;
import java.util.*;

class Result {

    public static int prims(int n, List<List<Integer>> edges, int start) {
        // Build adjacency list
        Map<Integer, List<int[]>> graph = new HashMap<>();
        for (List<Integer> edge : edges) {
            int u = edge.get(0);
            int v = edge.get(1);
            int w = edge.get(2);
            graph.computeIfAbsent(u, k -> new ArrayList<>()).add(new int[]{v, w});
            graph.computeIfAbsent(v, k -> new ArrayList<>()).add(new int[]{u, w});
        }

        // Min-heap for edges (weight, node)
        PriorityQueue<int[]> pq = new PriorityQueue<>(Comparator.comparingInt(a -> a[1]));
        Set<Integer> visited = new HashSet<>();
        pq.add(new int[]{start, 0});

        int totalWeight = 0;

        while (!pq.isEmpty()) {
            int[] current = pq.poll();
            int node = current[0];
            int weight = current[1];

            if (visited.contains(node)) continue;
            visited.add(node);
            totalWeight += weight;

            for (int[] neighbor : graph.getOrDefault(node, new ArrayList<>())) {
                if (!visited.contains(neighbor[0])) {
                    pq.add(new int[]{neighbor[0], neighbor[1]});
                }
            }
        }

        return totalWeight;
    }
}

public class Solution {
    public static void main(String[] args) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(System.getenv("OUTPUT_PATH")));

        String[] firstMultipleInput = bufferedReader.readLine().replaceAll("\\s+$", "").split(" ");
        int n = Integer.parseInt(firstMultipleInput[0]);
        int m = Integer.parseInt(firstMultipleInput[1]);

        List<List<Integer>> edges = new ArrayList<>();
        for (int i = 0; i < m; i++) {
            String[] edgeInput = bufferedReader.readLine().replaceAll("\\s+$", "").split(" ");
            List<Integer> edge = new ArrayList<>();
            for (String s : edgeInput) {
                edge.add(Integer.parseInt(s));
            }
            edges.add(edge);
        }

        int start = Integer.parseInt(bufferedReader.readLine().trim());
        int result = Result.prims(n, edges, start);

        bufferedWriter.write(String.valueOf(result));
        bufferedWriter.newLine();

        bufferedReader.close();
        bufferedWriter.close();
    }
}
