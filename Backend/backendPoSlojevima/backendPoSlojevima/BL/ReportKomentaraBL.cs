using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL
{
    public class ReportKomentaraBL : IReportKomentaraBL
    {
        private readonly IReportKomentaraDAL _IReportKomentaraDAL;
        private readonly IKomentariBL _IKomentariBL;
        private readonly IKorisnikBL _IKorisnikBL;
        private readonly List<ReportKomentari> reportKomentara;

        public ReportKomentaraBL(IReportKomentaraDAL IReportKomentaraDAL, IKorisnikBL IKorisnikBL, IKomentariBL IKomentariBL)
        {
            _IReportKomentaraDAL = IReportKomentaraDAL;
            _IKorisnikBL = IKorisnikBL;
            _IKomentariBL = IKomentariBL;
            reportKomentara = _IReportKomentaraDAL.getAllReport();
        }

        public long brojReportovaZaVlasnikaKomentara(long idKorisnika)
        {
            var komentari = _IKomentariBL.getKomentareByKorisnikId(idKorisnika);
            List<ReportKomentari> listaReportova = new List<ReportKomentari>();
            long brojReportovanihKomentara = 0;
            foreach (var komentar in komentari)
            {
                var report = this.getReportoveKomentaraByIdKomentara(komentar.id);
                if (report.Count() > 0)
                {
                    brojReportovanihKomentara++;
                }
                //  brojReportova += report.Count();
            }

           
            return brojReportovanihKomentara;
        }

        public void deleteReportoveKomentaraByIdKomentara(long idKomentara)
        {
            List<ReportKomentari> listaReporta = getReportoveKomentaraByIdKomentara(idKomentara);
            _IReportKomentaraDAL.deleteReportoveKomentara(listaReporta);
            
        }

        public void deleteReportoveKomentaraByIdKorisnika(long idKorisnika)
        {
            List<ReportKomentari> listaReporta = getReportoveKomentaraByKorisnikId(idKorisnika);
            _IReportKomentaraDAL.deleteReportoveKomentara(listaReporta);
            
        }

        public List<ReportKomentari> getAllReport()
        {
            return _IReportKomentaraDAL.getAllReport();
        }

        public long getBrojReportaByIdKomentara(long idKomentara)
        {
            long broj = reportKomentara.Where(r => r.KomentarID == idKomentara).Count();
            return broj;

        }
        
        public List<Korisnik> getKorisnikeKojiReportujuByIdKomentara(long idKomentara)
        {
            List<Korisnik> korisnici = new List<Korisnik>();
            var korisniciKojiSuLajkovali = reportKomentara.Where(o => o.KomentarID == idKomentara);
            foreach (var korisnik in korisniciKojiSuLajkovali)
            {
                Korisnik kor = _IKorisnikBL.getKorisnikaById(korisnik.KorisnikID);
                korisnici.Add(kor);
            }
            return korisnici;
        }

        public int getReportKomentaraByIdKorisnika(long idKorisnika, long idKomentara)
        {
            return _IReportKomentaraDAL.getReportKomentaraByIdKorisnika(idKorisnika, idKomentara);
        }

        public List<ReportKomentari> getReportoveKomentaraByIdKomentara(long idKomentara)
        {
            return reportKomentara.Where(r => r.KomentarID == idKomentara).ToList();
        }

        public List<ReportKomentari> getReportoveKomentaraByKorisnikId(long idKorisnika)
        {
            return reportKomentara.Where(r => r.KorisnikID == idKorisnika).ToList();
        }

        public long maxReportova()
        {
            var niz = from r in reportKomentara
                      group r by r.komentar into komentari
                      select new
                      {
                          idKorinsika = komentari.Key.KorisnikID,
                          ukupno = 1

                      };
            var nizBrojeva = from r in niz
                             select new
                             {
                                 idKorinsika = r.idKorinsika,
                                 ukupno = niz.Where(k => k.idKorinsika == r.idKorinsika).Count()

                             };

            var maxBroj = nizBrojeva.Max(m => m.ukupno);
            return maxBroj;
        }

        public void saveReport(ReportKomentari data)
        {
            _IReportKomentaraDAL.saveReport(data);
        }
    }
}
