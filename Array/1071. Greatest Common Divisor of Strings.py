class Solution:
    def gcdOfStrings(self, str1: str, str2: str) -> str:
        result = ""
        i = 1
        while i <= len(str1):
            if len(str1) % i == 0:
                temp = str1[0 : int(len(str1) / i)]
                temp2 = temp * int(len(str1) / len(temp))
                if temp2 == str1 and len(str2) % len(temp) == 0:
                    temp3 = temp * int(len(str2) / len(temp))
                    if temp3 == str2:
                        result = temp
                        break
            i += 1
        return result


str1, str2 = "LEET", "CODE"

print(Solution().gcdOfStrings(str1, str2))
