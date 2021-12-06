
import numpy as np
arr = np.memmap('output')
arr2 = np.memmap('output2')
arrd = np.memmap('diagout')

arr.shape
marr = arr.reshape((1024,1024))
marr2 = arr2.reshape((1024,1024))
marrd = arrd.reshape((1024,1024))

figure()
imshow(marrd[0:200, 0:200])
figure()
imshow(marrd)
np.sum(marr > 1)
np.sum(marr2 > 1)
550459/5573


