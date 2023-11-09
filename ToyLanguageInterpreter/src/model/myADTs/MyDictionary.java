package model.myADTs;

import java.util.Dictionary;
import java.util.Hashtable;

public class MyDictionary <K, V> implements MyIDictionary<K, V>{
    private Hashtable<K, V> dictionary;

    public MyDictionary() {
        dictionary = new Hashtable<K, V>();
    }

    @Override
    public V get(Object key) {
        return dictionary.get(key);
    }

    @Override
    public boolean isEmpty() {
        return dictionary.isEmpty();
    }

    @Override
    public V put(K key, V value) {
        return dictionary.put(key, value);
    }

    @Override
    public V remove(Object key) {
        return dictionary.remove(key);
    }

    @Override
    public int size() {
        return dictionary.size();
    }

    @Override
    public void clear() {
        dictionary.clear();
    }

    @Override
    public String toString() {
        return "Symbol Table: " + dictionary.toString();
    }
}
