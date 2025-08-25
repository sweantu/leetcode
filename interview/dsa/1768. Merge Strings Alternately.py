from itertools import zip_longest


class Solution:
    def mergeAlternately(self, word1: str, word2: str) -> str:
        chars = []
        for i in range(max(len(word1), len(word2))):
            if i < len(word1):
                chars.append(word1[i])
            if i < len(word2):
                chars.append(word2[i])
        return ("").join(chars)

    def mergeAlternately2(self, word1: str, word2: str) -> str:
        return "".join((a or "") + (b or "") for a, b in zip_longest(word1, word2))


word1 = "abcd"
word2 = "pq"

print(Solution().mergeAlternately2(word1, word2))
