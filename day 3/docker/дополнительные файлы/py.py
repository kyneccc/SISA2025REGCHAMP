import os.path
check_file = os.path.exists( '/root/input.txt' )

if check_file == True:
    TEST = open( '/root/input.txt' )
    print ( *TEST )
else:
    print ( "ERROR, file not found"  )
