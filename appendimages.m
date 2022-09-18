% im = appendimages(image1, image2)
%
% Kembalikan gambar baru yang menambahkan dua gambar secara berdampingan.

function im = appendimages(image1, image2)

%   Pilih gambar dengan baris paling sedikit dan isi baris kosong yang cukup
%   untuk membuatnya sama tingginya dengan gambar lainnya.
rows1 = size(image1,1);
rows2 = size(image2,1);

if (rows1 < rows2)
     image1(rows2,1) = 0;
else
     image2(rows1,1) = 0;
end

% Sekarang tambahkan kedua gambar secara berdampingan.
im = [image1, image2];   
