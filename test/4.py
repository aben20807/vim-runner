print("Hello python!")
value_list = []
get_values = input()
value_list = get_values.split()
sum = 0
for i in range(len(value_list)):
    sum = sum + int(value_list[i])
print(sum)
