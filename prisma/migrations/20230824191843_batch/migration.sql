-- CreateEnum
CREATE TYPE "TemplateType" AS ENUM ('JINJA', 'EJS', 'JSTL');

-- CreateEnum
CREATE TYPE "BatchStatus" AS ENUM ('submitted', 'queued', 'running', 'done', 'aborted');

-- CreateEnum
CREATE TYPE "OutputType" AS ENUM ('png', 'jpeg', 'html', 'pdf', 'qr');

-- CreateTable
CREATE TABLE "Template" (
    "id" SERIAL NOT NULL,
    "content" TEXT NOT NULL,
    "templateType" "TemplateType" NOT NULL,

    CONSTRAINT "Template_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Batch" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "templateType" "TemplateType" NOT NULL,
    "templateID" INTEGER NOT NULL,
    "payload" JSONB[],
    "status" "BatchStatus" NOT NULL DEFAULT 'submitted',
    "output" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "outputType" "OutputType" NOT NULL DEFAULT 'pdf',

    CONSTRAINT "Batch_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Batch" ADD CONSTRAINT "Batch_templateID_fkey" FOREIGN KEY ("templateID") REFERENCES "Template"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
