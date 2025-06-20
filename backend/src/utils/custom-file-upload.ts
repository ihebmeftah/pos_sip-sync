import { FileFieldsInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';

// Utility to generate unique filenames
const editFileName = (req, file, callback) => {
    const name = file.originalname.split('.')[0];
    const fileExtName = extname(file.originalname);
    const randomName = Array(8)
        .fill(null)
        .map(() => Math.round(Math.random() * 16).toString(16))
        .join('');
    callback(null, `${name}-${randomName}${fileExtName}`);
};

// Multer storage config
export const multerStorage = (dest: string) =>
    diskStorage({
        destination: dest,
        filename: editFileName,
    });

// Reusable interceptor factory for single/multiple fields
export function CustomFileUploadInterceptor(fields: { name: string; maxCount: number }[], dest = './uploads') {
    return FileFieldsInterceptor(fields, { storage: multerStorage(dest) });
}
