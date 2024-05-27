package utils;

import java.io.File;
import java.io.IOException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class TestDataManager {
    private static String _env = null;

    public static void initialize(String env) {
        if (_env == null || !_env.equals(env)) {
            _env = env;
        }
        System.out.println("Initialized TestDataManager with environment: " + _env);
    }

    private static JsonNode getTestDataFromJSON(String _file) throws IOException {
        File file = new File("src/test/resources/data/" + _file);
        System.out.println("Reading test data from: " + file.getAbsolutePath());
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.readTree(file);
    }

    public static JsonNode getData(String file) {
        try {
            JsonNode dataJsonNode = getTestDataFromJSON(file);
            System.out.println("Loaded data for environment: " + _env);
            JsonNode dataNode = dataJsonNode.get(_env);

            if (dataNode != null) {
                return dataNode;
            } else {
                System.out.println("No data available for environment: " + _env);
                return null;
            }
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}
