% showkeys(image, locs)
%
% Fungsi ini menampilkan gambar dengan titik tombol SIFT dilapis.
%   Input parameters:
%     image: nama file untuk gambar (skala abu-abu)
%     locs: matriks di mana setiap baris memberikan lokasi keypoint (baris,
%           kolom, skala, orientasi)
% contoh:  [image, descrips, locs] = sift('photo_test.jpeg');
%  showkeys(image, locs);


function showkeys(image, locs)

disp('Drawing SIFT keypoints ...');

% Menggambar gambar dengan keypoints
figure('Position', [50 50 size(image,2) size(image,1)]);
colormap('gray');
imagesc(image);
hold on;
imsize = size(image);
for i = 1: size(locs,1)
    % Gambarlah panah, setiap garis diubah sesuai dengan parameter keypoint.
    TransformLine(imsize, locs(i,:), 0.0, 0.0, 1.0, 0.0);
    TransformLine(imsize, locs(i,:), 0.85, 0.1, 1.0, 0.0);
    TransformLine(imsize, locs(i,:), 0.85, -0.1, 1.0, 0.0);
end
hold off;


% ------ Subroutine: TransformLine -------
% Gambar garis yang diberikan pada gambar, tetapi pertama-tama terjemahkan, putar, dan
% skala sesuai dengan parameter keypoint.
%
% Parameters:
%   Arrays:
%    imsize = [baris kolom] gambar
%    keypoint = [subpixel_row subpixel_column scale orientation]
%
%   Scalars:
%    x1, y1; awal vektor
%    x2, y2; akhir dari vektor
function TransformLine(imsize, keypoint, x1, y1, x2, y2)

%Penskalaan panah panjang satuan diatur ke kira-kira radius
%   dari wilayah yang digunakan untuk menghitung deskriptor keypoint.
len = 6 * keypoint(3);

% Putar keypoint dengan 'ori' = keypoint(4)
s = sin(keypoint(4));
c = cos(keypoint(4));

% Apply transform
r1 = keypoint(1) - len * (c * y1 + s * x1);
c1 = keypoint(2) + len * (- s * y1 + c * x1);
r2 = keypoint(1) - len * (c * y2 + s * x2);
c2 = keypoint(2) + len * (- s * y2 + c * x2);

line([c1 c2], [r1 r2], 'Color', 'c');

