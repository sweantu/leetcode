class Solution:
    def reverseVowels(self, s: str) -> str:
        vowels = ["a", "e", "i", "o", "u"]
        vowels_list = [char for char in s if char.lower() in vowels]
        result = [
            char if char.lower() not in vowels else vowels_list.pop() for char in s
        ]
        return "".join(result)


s = "IceCreAm"
print(Solution().reverseVowels(s))
